# FB5 reproducible-artifact checks (research PDK, not a foundry deliverable)
# Requires: python3 (numpy), ngspice, klayout, magic, netgen (optional).
SHELL := /bin/bash
ROOT  := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
TMP   := $(shell mktemp -d /tmp/fb5-check-XXXXXX)

.PHONY: check check-static check-lef check-parasitics check-gilbert regenerate

# Full clean-room regression: copy the whole tree (no .git), regenerate every
# model card / LEF check / validation report / 5HP extraction tech / extracted
# netlist, and diff.  Nothing in $(ROOT) is modified.
check: check-static
	@set -e; \
	tar --exclude='./.git' --exclude='__pycache__' --exclude='runs_*' \
	    -cf - -C $(ROOT) . | (cd $(TMP) && tar xf -); \
	echo "== LEF =="; \
	cd $(TMP)/digital/lef && klayout -b -r check_lef.py > lef_check.log 2>&1; \
	grep -q 'LEF CHECK: PASS' $(TMP)/digital/lef/lef_check.log; \
	echo "== models =="; \
	cd $(TMP)/models && \
	  python3 fit_hbt.py > fit_hbt.txt 2>&1 && \
	  python3 fit_vbic.py > fit_vbic.txt 2>&1 && \
	  python3 build_corners.py > build_corners.txt 2>&1; \
	echo "== validation =="; \
	cd $(TMP)/validation && \
	  python3 val_fmax.py --sensitivity > val_fmax.txt 2>&1 && \
	  python3 val_fb5.py > val_fb5.txt 2>&1 && \
	  python3 val_vbic.py > val_vbic.txt 2>&1; \
	echo "== parasitics / post-layout (5HP WAT table: measured + PROXY) =="; \
	cd $(TMP)/validation/parasitics && \
	  python3 fb5_5hp_rc.py > /dev/null && \
	  python3 extract.py --all > extract.txt 2>&1 && \
	  python3 postlayout.py > postlayout.txt 2>&1 && \
	  python3 chain.py > chain.txt 2>&1 && \
	  python3 rc_compare.py > rc_comparison.txt 2>&1; \
	for f in models/fb5_hbt.lib models/fb5_hbt_vbic.lib \
	         models/fit_hbt.txt models/fit_vbic.txt models/build_corners.txt \
	         validation/val_fmax.txt validation/val_fb5.txt validation/val_vbic.txt \
	         validation/parasitics/extract.txt validation/parasitics/postlayout.txt \
	         validation/parasitics/chain.txt validation/parasitics/rc_comparison.txt \
	         validation/parasitics/SCN3ME_SUBM.30.5hp.tech; do \
	  if diff -q $(ROOT)/$$f $(TMP)/$$f >/dev/null; then echo "OK   $$f"; \
	  else echo "FAIL $$f"; diff -u $(ROOT)/$$f $(TMP)/$$f | head -30; exit 1; fi; \
	done; \
	python3 $(ROOT)/validation/parasitics/check_netlists.py \
	    $(ROOT)/validation/parasitics/netlists $(TMP)/validation/parasitics/netlists \
	    > $(TMP)/netlist_check.txt 2>&1; \
	grep -q 'NETLIST CHECK: PASS' $(TMP)/netlist_check.txt || \
	  { cat $(TMP)/netlist_check.txt; exit 1; }; \
	echo "OK   validation/parasitics/netlists/ (33 files, semantic check)"; \
	rm -rf $(TMP); echo "make check: PASS"

# Static portability / syntax checks (no external scripts, no absolute paths).
check-static:
	@echo "== static: no hardcoded home paths / external scripts =="
	@! grep -rn --exclude-dir=.git --exclude-dir='runs_*' --exclude='*.pyc' --exclude=Makefile \
	    -E '/home/fpga|/home/yanlu|/grid/fb5-pdk|~/fpga-projects|~/ext/mosis_cards|~/tools/scl_pinned|~/pdks/tools' $(ROOT)
	@echo "== static: python syntax =="
	@python3 -m py_compile $(ROOT)/models/*.py $(ROOT)/validation/*.py \
	    $(ROOT)/validation/parasitics/*.py $(ROOT)/validation/gilbert_glenn95/*.py \
	    $(ROOT)/digital/lef/*.py $(ROOT)/klayout/pcells/*.py $(ROOT)/passives/inductor/*.py
	@echo "OK"

check-lef:
	@cd $(ROOT)/digital/lef && klayout -b -r check_lef.py

# Re-run the parasitic extraction / post-layout flow in place.
check-parasitics:
	cd $(ROOT)/validation/parasitics && python3 fb5_5hp_rc.py
	cd $(ROOT)/validation/parasitics && python3 extract.py --all > extract.txt
	cd $(ROOT)/validation/parasitics && python3 postlayout.py > postlayout.txt
	cd $(ROOT)/validation/parasitics && python3 chain.py > chain.txt
	cd $(ROOT)/validation/parasitics && python3 rc_compare.py > rc_comparison.txt

# Re-run the full Gilbert-mixer paper regression (~6 min on 12 cores).
check-gilbert:
	cd $(ROOT)/validation/gilbert_glenn95 && bash run.sh

# Regenerate all checked-in artifacts in place (review the diff afterwards).
# Note: fb5.lib is validated, not overwritten (use build_corners.py --write to replace).
regenerate:
	cd $(ROOT)/models && python3 fit_hbt.py > fit_hbt.txt && \
	  python3 fit_vbic.py > fit_vbic.txt && python3 build_corners.py > build_corners.txt
	cd $(ROOT)/validation && python3 val_fmax.py --sensitivity > val_fmax.txt && \
	  python3 val_fb5.py > val_fb5.txt && python3 val_vbic.py > val_vbic.txt
	$(MAKE) check-parasitics
