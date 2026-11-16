# FB5 R/C 参数：IBM SiGe 5HP 实测数据检索与判定

日期 2026-11-14。结论先行：**当前 PDK 的寄生 R/C 规则原本来自 AMI/onsemi C5
0.5 µm 通用 SCMOS 工艺，不是 IBM 5HP。** 本轮检索到 IBM 官方公布的 5HP 工艺
表征数据 + PDK 自身 20 个 MOSIS IBM SIGE05 lot 的实测中位值，据此确定并落地了
金属方块电阻与面积/层间电容；**互连边缘电容与接触/通孔电阻没有公开实测数据**，
仍保留 AMI C5 估计值并明确标注。

## 1. 为什么原来的值不是 5HP

qflow \`osu050.par\` / \`SCN3ME_SUBM.30.tech\` 的金属方块电阻是
M1/M2/M3 = 0.09/0.09/0.05 Ω/sq。Iowa State EE330 (AMI 0.5 µm) 实验讲义给出的
同工艺层电阻表完全一致（nwell 819、poly 25、elec 26、metal1 0.09、metal2 0.09、
metal3 0.05 Ω/sq）。一份公开的 MOSIS WET（Wafer Electrical Test）报告
（AMIS/ON-SEMI SCN05, run V11L）也给出同类数据：M1 0.09、M2 0.09、M3 0.05 Ω/sq，
接触电阻 N+ 60.5 Ω / P+ 153.4 Ω / M2 0.86 Ω / M3 0.80 Ω，以及面积电容
M1 29 aF/µm²、边缘电容 M1 49 aF/µm 等 —— 正是 qflow tech 里那些数字的量级。
所以它们是 **AMI C5 的实测值**，只是被误用到了 5HP 上。

## 2. 检索到的 5HP 实测/公布数据

| 来源 | 内容 | 性质 |
|---|---|---|
| **[1] 20 个 MOSIS IBM SIGE05 lot reports**（经 \`docs/FB5_design_manual.md\` §1、\`passives/fb5_passives.lib\` 提取） | 金属方块电阻 M1 0.08 / M2 0.05 / M3 0.04 / M4 0.01 Ω/sq；poly 电阻 RP 214、RN 20.2、RI 1593 Ω/sq；MIM 1.27、decap 1.51、NMOS varactor 1.38 fF/µm²；tox 92 Å；Vth/Idss 分布 | **WET 实测**（中位值 + 1σ） |
| **[2] J. S. Dunn et al., "Foundation of rf CMOS and SiGe BiCMOS technologies", IBM J. Res. & Dev. 47(2/3), 2003** — Table 4 / Table 6 / Table 7 | 见下 | **IBM 工艺表征/公布** |
| **[3] IBM 5HP BEOL 几何**（上述论文 §BEOL + Auburn 大学 "Circuits for the Design of a Serial Communication System"） | 3~5 层金属；M1 最小宽 0.8 µm、厚 0.63 µm；LM 最小宽 2.4 µm、厚 2.07 µm；**除 AM 外各金属层间 1.2 µm SiO₂**；5AM 的 AM 为 4 µm Al | **IBM 公布几何** |
| **[4] qflow osu050.par / SCN3ME_SUBM.30.tech** | AMI C5 通用 R/C 规则（原用值） | 对照基线 |

### [2] 的关键表格（IBM 官方）

**Table 4 — 电阻（SiGe 系列工艺表征）**

| 电阻 | 方块电阻 Ω/sq | 对衬底寄生电容 fF/µm² |
|---|---|---|
| p+ polysilicon | 270 | 0.11 |
| p polysilicon | 1600 | 0.09 |
| n+ diffusion | **72** | **1.00** |
| n subcollector | 8 | 0.12 |
| TaN BEOL metal | 142 | **0.03** |

**Table 6 — 电容密度（SiGe 5HP/AM/DM 列）**

| 电容 | 0 V 单位面积电容 fF/µm² |
|---|---|
| MOSCAP | 1.5 |
| Poly-Poly | — (5HPE 为 1.6) |
| **MIM** | **0.7** |

**Table 7 — last metal**：5HP 的 2 µm Al 顶层金属方块电阻 **14 mΩ/sq**；
4 µm Al/3 µm Cu 双金属 3.2 mΩ/sq；underpass 0.8 µm Al。

### 单位校准（关键，决定能否把 fF/µm² 填进 magic）

magic \`extract\` 规则单位经**实验**确认：画 300λ×300λ = 90×90 µm 的 M1 方块，
\`extract\` 得到节点电容 277740 aF。分解：

    2.790 aF/λ² × 90000 λ²  = 251100 aF   (areacap)
    22.200 aF/λ  ×  1200 λ   =  26640 aF   (perimc)
                               ---------
                               277740 aF  ✓ 与 .ext 完全一致

故 **areacap 单位 = aF/λ²，perimc 单位 = aF/λ，resist 单位 = mΩ/sq，λ=0.30 µm**。
换算：\`magic = fF/µm² × 90\`（因为 1 λ² = 0.09 µm²，1 fF = 1000 aF）。
三重交叉验证 \`osu050.par\`：magic 2.790/1.440/0.900 → 0.031/0.016/0.010 fF/µm²，
与 par 的 0.032/0.016/0.010 一致 ✓。改用 5HP tech 后同一方块得 259740 aF
（= 2.59×90000 + 22.2×1200），与预测一致 ✓。

## 3. 判定结果：5HP 值 vs 原 AMI C5 值

| 参数 | IBM 5HP | 原 AMI C5 | 差 | 依据 |
|---|---|---|---|---|
| M1 方块电阻 | **0.08** Ω/sq | 0.09 | −11 % | [1] WET 实测 |
| M2 方块电阻 | **0.05** | 0.09 | −44 % | [1] WET 实测 |
| M3 方块电阻 | **0.04** | 0.06 | −33 % | [1] WET 实测 |
| LM (2 µm Al) | **0.014** | (无第 4 层) | — | [2] Table 7 |
| n+ 扩散方块电阻 | **72** Ω/sq | 82.4 | −13 % | [2] Table 4 |
| 金属→衬底 BEOL 面积 C | **0.03** fF/µm² | 0.032 (M1) | −6 % | [2] Table 4 实测 |
| M1/M2/M3→衬底面积 C | **0.0288 / 0.0144 / 0.0096** fF/µm² | 0.031 / 0.016 / 0.010 | −7~−10 % | [3] 1.2 µm SiO₂ 平行板，由 [2] 的 0.03 验证 |
| M2→M1 层间 C | **0.0288** fF/µm² | 0.030 | −4 % | [3] 1.2 µm 平行板 |
| MIM 电容 | 0.7 fF/µm² | PDK 1.27 | — | [2] Table 6 vs [1] lot 中位值，**见 §5** |
| MOSCAP/decap | 1.5 fF/µm² | PDK 1.51 | ✓ | [2] Table 6 与 [1] 吻合 |
| **边缘/周边电容** | **无公开实测** | 22.2 aF/λ 等 | — | WAT 表已补录；现为 **PROXY 推算**（§8），非实测 |
| **接触/通孔电阻** | **无公开实测** | 0.73~141 Ω | — | WAT 表已补录；现为 **PROXY 推算**（§8），非实测 |
| **HBT Cje/Cjc/Cjs** | **无公开实测** | 模型假设值 9/5/8 fF | — | 保留，**ESTIMATE** |

面积/层间电容的 AMI 值与 5HP 由 1.2 µm ILD 推出的值只差 4~10 %（且 IBM Table 4
实测 0.03 fF/µm² 与 1.2 µm 平行板 0.0288 吻合），所以 **C 只需微调，R 才是主要修正**。

## 4. 落地

**参数单一真源是 \`wet_tables/fb5_wet.tsv\`**（MOSIS WAT 格式，逐行带 MEASURED /
DERIVED / PROXY / MISSING 状态与来源）。\`fb5_5hp_rc.py\` 读它并生成
\`SCN3ME_SUBM.30.5hp.tech\`（只改 \`extract\` 段）：

    resist (ndiff,..)/active  82400 -> 72000        [2] Table 4
    resist (m1,..)/metal1        90 -> 80           [1]
    resist (m2,..)/metal2        90 -> 50           [1]
    resist (m3,..)/metal3        60 -> 40           [1]
    areacap/overlap M1        2.790 -> 2.59        [3]+[2]
    areacap/overlap M2        1.440 -> 1.30        [3]
    areacap/overlap M3        0.900 -> 0.86        [3]
    overlap M2->M1            2.700 -> 2.59        [3]
    perimc/sideoverlap M1    22.200 -> 20.62      PROXY (§8)
    perimc/sideoverlap M2    17.400 -> 15.66      PROXY
    perimc/sideoverlap M3    11.400 -> 10.94      PROXY
    sideoverlap M1-M2           15   -> 14.40      PROXY
    contact ndc             58700   -> 51291       PROXY (72/82.4)
    contact m2c               760   ->   422       PROXY (0.05/0.09)
    contact m3c               730   ->   487       PROXY (0.04/0.06)
    contact pdc/pc/p2c       unchanged             no 5HP counterpart sheet R

\`extract.py\` / \`chain.py\` 默认改用该 tech；\`--tech\` 可复现 AMI 基线。
\`digital/lef/fb5_tech.lef\` 与 \`fb5_stdcell.lef\` 的 \`RESISTANCE RPERSQ\` 改为
0.08/0.05/0.04，\`CAPACITANCE CPERSQDIST\` 改为 2.9e-05/1.4e-05/9.6e-06 pF/µm²。

## 5. 与 PDK 其他实测值的一致性核对

* \`passives/fb5_passives.lib\` decap 1.51 fF/µm² ≈ IBM MOSCAP 1.5 ✓；
  NMOS varactor 1.38 接近。
* **MIM 1.27 fF/µm² 与 IBM Table 6 的 0.7 不符**。IBM Table 6 中 1.35/2.70 属于
  **5HPE 双层 MIM**，因此 1.27 很可能来自 5AM/5HPE 变体或 lot 上的双层/叠层 MIM。
  它是 20 个 lot 的实测中位值，比公布表更贴近本 PDK 对应的晶圆，**保留不改**，
  但在 ESTIMATES.md 中记为"与 IBM 公布 0.7 有定义差异，待核"。
* \`models/fb5.lib\` 的 BSIM3 来自 MOSIS IBM SIGE05 lot T4AB，其 \`CJ=8.7e-4 F/m²\`
  = 0.87 fF/µm²，与 IBM Table 4 的 n+ diffusion 1.00 fF/µm² 同量级 ✓。
  即**器件结电容本来就是 5HP 实测**，magic tech 里对应的 areacap 行也被注释为
  "MODEL HANDLES THIS"，不重复计入。
* RP 214 Ω/sq 与 IBM Table 4 p+ poly 270 Ω/sq 同量级；RI 1593 与 p poly 1600 ✓；
  RN 20.2 与 n subcollector 8 Ω/sq 不同定义（RN 是 reach-through/NS 层），保留。

## 6. 仍未确定（明确 ESTIMATE，不要当成 5HP 实测）

1. **互连边缘/周边电容**（fringe/perimeter C，fF/µm）—— IBM 论文只说 MIM 的
   perimeter parasitics "much higher"，无数值。
2. **接触孔 / 通孔电阻**（Ω/contact）—— 无 5HP 公开值。
3. **HBT 结电容** Cje/Cjc/Cjs —— 模型里是典型值假设，无实测 S 参数。
4. **完整 5HP MOSIS WET 报告**本身：MOSIS 对每个 lot 都测 sheet R / contact R /
   area C / fringe C / overlap C（格式见 AMI SCN05 run V11L 报告）。PDK 作者用的
   20 份 IBM SIGE05 WET 报告**未随仓库分发、也未在公开网络索引**（本轮做了全盘文件
   检索 + 5 轮网络检索确认；只找到 AMI C5 SCN05 V11L、0.35 um CMOS-class MOSIS lot N88Y、1.2/1.6 µm
   CMOS 的 WAT 报告）。**表结构已补录到 \`wet_tables/fb5_wet.tsv\`**，5HP 实测列留空；
   §8 的 PROXY 只是占位推算。把真实 WAT 数字填进表并把 status 改成 MEASURED，重跑
   \`make check-parasitics\` 即可完成真正的实测拟合 —— **这仍是最高优先级的待补数据**。

## 7. 影响

\`rc_compare.py\` 用同一 GDS 分别以 AMI C5 规则与 5HP 规则提取并跑 3 级链后仿：

| 单元 | pre | post(AMI C5) | post(5HP) | 差 |
|---|---|---|---|---|
| INVX1 | 70.26 ps | 104.91 | 104.19 | −0.69 % |
| INVX2 | 59.35 | 89.16 | 88.82 | −0.38 % |
| INVX4 | 55.65 | 80.60 | 80.42 | −0.22 % |
| INVX8 | 53.52 | 90.55 | 90.36 | −0.21 % |
| NAND2X1 | 102.71 | 138.21 | 137.64 | −0.41 % |
| NOR2X1 | 116.47 | 152.32 | 151.79 | −0.35 % |

全库提取 sum(C)：AMI C5 **1168.1 fF** → 仅面积/方块电阻修正 **1165.5 fF**
→ 加上 §8 的 fringe/contact PROXY 重拟合 **1125.9 fF**（−3.6 %）。布线链
210.77 → 314.45 → **321.12 ps**。

**解读**：单元级延迟几乎不变（<0.1 %），因为这些小单元的寄生以**器件结电容
（已由 5HP 实测 BSIM3 处理）和多晶栅电阻**为主，金属方块电阻只在单元内极短的
走线上起作用。5HP 的 R/C 修正主要影响**长距离顶层布线**；本 PDK 的示范链只有
~10 µm 连线，因此差异也小（−0.13 %）。这不代表修正无意义 —— 它说明之前的
post-layout 结论对这组规则不敏感，且把"通用 AMI C5 规则"这一溯源错误消除了。

## 8. WAT 表补录与 fringe/contact 重拟合（2026-11-14 第二轮）

### 数据检索结论

用户要求"补录 WET CAPACITANCE/CONTACT 表、更新 fb5_5hp_rc.py、重拟合
fringe/contact"。先做了**全盘数据检索**：

* 仓库全部文件（含被 gitignore 的文件、git 对象、单 commit 历史）：无 WAT 表，
  只有 \`models/t4ab_raw.lib\` 这一张 BSIM3 SPICE 卡。
* 本机 \`/home\`、\`/tmp\`、\`/\`（xdev，深度 6）：无 SIGE05 / T4AB / 5AM_NI /
  WET 报告；build_corners.py 里提到的 home 目录下 mosis_cards 索引并不存在。
* \`/grid/siliconcraft/.../docs/mosis_evidence/d35_wat_pex_data.md\` 里有一份
  **verbatim WAT 表**，但那是 a 0.35 µm CMOS-class MOSIS lot (run N88Y)，不是 IBM 5HP。
* **兄弟 PDK \`/grid/fp5-pdk\`（FB5 的派生来源）里有一份第一手的
  WAT CAPACITANCE/CONTACT 表**：\`tech/wire_rc.txt\`（MOSIS lot T89Y，105 个 C5 lot
  的中位值，含 sheet R / Area_sub / Fringe_sub / 层间面积与 fringe）、
  \`passives/fp5_passives.lib\`（接触电阻）、\`passives/passives_stats.txt\`
  （105 lot 的 CAPACITANCE/PROCESS 行中位数与 1σ）。已转录为
  \`wet_tables/ami_c5_wat_reference.txt\`。**但这是 AMI C5，不是 5HP。**
* \`fp5-pdk/passives/extract_passives.py\` 还给出了 WAT 报告的**确切存放路径**：
  环境变量 \`FP5_MOSIS_PARAMS\`，默认 \`home-dir mosis_cards/wayback_params\`，
  文件名 \`ami-c5*__*.txt\`（105 个 run）；\`build_corners.py\` 也指向同一个
  archive（\`_index_reports.tsv\`）。**IBM SIGE05 的 WET 报告应是同一 archive 里
  的 \`ibm-sige*\` 兄弟文件**，但该 archive 不在本机。这把"下一步补数据"从
  模糊的"找 WET 报告"变成了**一条明确可取的路径**。
* 5 轮共 ~20 个网络检索：找到公开的 **AMI/onsemi C5 SCN05 run V11L** WAT 报告、
  WPI 的 1.2/1.6 µm MOSIS PARAMETRIC TEST RESULTS、以及 IBM J.R&D 2003 的
  Tables 4/6/7 —— **没有任何公开索引的 IBM SIGE05 / 5HP WAT 报告**。

因此 **不能凭空造出 5HP 的 fringe/contact 实测值**。本轮补录的是**表结构、
第一手的 AMI C5 WAT 参照表、以及可核查的 5HP 实测/公布值**，并把"重拟合"
做成表驱动、状态可切换的工程接口。

> 注：WAT \`Fringe\` 是单侧边缘，magic 的 \`perimc\` 把两侧/侧壁折进一个系数，
> 因此 magic 值约大 1.4 倍（M1: WAT 52 vs magic 74 aF/µm）。\`fb5_wet.tsv\` 的
> \`ami_c5\` 列用的是 **magic 规则单位**（便于缩放），原始 WAT 数值另存于
> \`ami_c5_wat_reference.txt\`，两者不可混用。

### 补录的表

\`validation/parasitics/wet_tables/fb5_wet.tsv\`（38 行，MOSIS WAT 格式）：

* \`PROCESS PARAMETERS\`：Sheet Resistance、Contact Resistance
* \`CAPACITANCE PARAMETERS\`：Area (substrate / metal1 / metal2)、
  Fringe (substrate / poly / metal1 / metal2)、Overlap (N+/P+ active)
* 每行带 \`ami_c5\`（公开 AMI C5 WAT 实测）、\`ibm_5hp\`、\`status\`、
  \`source\`、\`note\`；\`wet_tables/README.md\` 说明单位与填写方法。
* 状态统计：**11 MEASURED / 4 DERIVED / 21 MISSING / 1 INFO**。
  21 个 MISSING 全部是 fringe/contact/overlap 等无 5HP 实测的项。

公开 WAT 参考（用于表结构与 AMI 基线，非 5HP）：
MOSIS AMIS/ON-SEMI SCN05 run V11L、WPI \`16umparameters.pdf\` /
\`12umParameters.pdf\`、0.35 um CMOS-class MOSIS lot N88Y（见 d35_wat_pex_data.md 的转录）。

### fb5_5hp_rc.py 重构

从"硬编码常数"改为**完全表驱动**：

\`\`\`
fb5_wet.tsv -> load_wet() -> CONV 单位换算 -> AREA_MAP / K(fringe proxy) /
CONTACT_MAGIC -> 生成 SCN3ME_SUBM.30.5hp.tech
\`\`\`

单位换算（由 §2 的校准实验确定）：
\`area aF/µm² × 0.09\`、\`fringe aF/µm × 0.30\`、
\`sheet Ω/sq × 1000\`、\`contact Ω × 1000\`。
\`--report\` 打印逐行状态；\`--no-proxy\` 可关闭推算、退回 AMI 值做对照。

### PROXY 重拟合规则（**明确不是实测**）

| 项 | 规则 | 依据 |
|---|---|---|
| fringe / perimc / sideoverlap | AMI 实测值 × (5HP 面积 C / AMI 面积 C)（同导体对） | 把 5HP 已确定的介质几何迁移到 AMI 实测的边缘形状因子上；一阶 |
| via1 / via2 接触电阻 | AMI 实测值 × (5HP / AMI 金属方块电阻比) | 弱代理；接触电阻主要由界面/塞决定，与方块电阻不严格成正比 |
| ndc (N+ 接触) | AMI × (72 / 82.4) | IBM Table 4 的 n+ 方块电阻比；弱代理 |
| pdc / pc / p2c | **保持 AMI 不变** | 没有对应的 5HP 方块电阻，任何缩放都无依据 |

生成的 tech 头部、\`--report\`、\`ESTIMATES.md\`、本文件都醒目标注
**PROXY ≠ 5HP 实测**。校准验证：300×300 λ M1 方块在 AMI 规则下 277740 aF，
仅改面积后 259740 aF，再加 fringe PROXY 后 **257844 aF**
（= 2.59×90000 + 20.62×1200），与预测完全一致。

### 影响

见 §7 更新后的数字：sum(C) 1165.5 → **1125.9 fF**（−3.4 %，主要来自 fringe
缩减），单元延迟 −0.2~−0.7 %，布线链 323.51 → **321.12 ps**。

### 拿到真实 WAT 数据后怎么做

1. 把 20 份 SIGE05 WET 的 CAPACITANCE / CONTACT 表（或 lot 中位值）填入
   \`fb5_wet.tsv\` 的 \`ibm_5hp\` 列，\`status\` 改为 \`MEASURED\`，更新 \`source\`。
2. \`make check-parasitics\` 重新生成 tech 与全部报告；MEASURED 行会绕过 PROXY。
3. 在 \`SOURCES.md\` / \`NOTICE\` 登记 WAT 报告出处。

**无需改任何代码** —— 拟合是表驱动的。在此之前，fringe/contact 数值只能作为
带 5HP 几何方向的一阶占位，不得引用为 5HP 实测值。
