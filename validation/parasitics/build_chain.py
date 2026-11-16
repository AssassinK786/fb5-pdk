import pya, os
HERE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(HERE,'..','..'))
SRC=os.path.join(ROOT,'digital','gds','osu05_stdcells.gds2')
OUT=os.path.join(HERE,'fb5_inv_chain.gds')
ly=pya.Layout(); ly.read(SRC)
u=1.0/ly.dbu                       # db units per um
def box(x1,y1,x2,y2): return pya.Box(int(x1*u),int(y1*u),int(x2*u),int(y2*u))
def L(n,d): return ly.layer(n,d)
m1=L(49,0); lab=L(109,0)
inv=ly.cell_by_name('INVX1')
assert inv is not None and inv>=0
top=ly.create_cell('FB5_INV_CHAIN')
xs=(0.0,12.0,24.0)
for x in xs:
    top.insert(pya.CellInstArray(inv, pya.Trans(pya.Trans.R0, pya.Point(int(x*u),0))))
# power rails across all three cells (metal1, abutting each cell's own rails)
top.shapes(m1).insert(box(-0.6,-0.9, 29.4,0.9))
top.shapes(m1).insert(box(-0.6,29.1, 29.4,30.9))
# input / output stubs
top.shapes(m1).insert(box(-3.0,6.9, 1.8,8.1))
top.shapes(m1).insert(box(27.0,9.9, 32.1,11.1))
# stage i -> stage i+1: horizontal at y=10.5 then down to A pin y=7.5
for x,nx in zip(xs[:-1],xs[1:]):
    yx=x+3.6; ax=nx+1.2
    top.shapes(m1).insert(box(yx-0.6,9.9, ax+0.6,11.1))
    top.shapes(m1).insert(box(ax-0.6,7.5, ax+0.6,11.1))
# port labels (GDS 109/0 = m1_label, magic reads these)
for t,x,y in (('in',-2.1,7.5),('out',31.5,10.5),('vdd',9.0,30.0),('gnd',9.0,0.0)):
    top.shapes(lab).insert(pya.Text(t,int(x*u),int(y*u)))
ly.write(OUT)
print('wrote',os.path.relpath(OUT,ROOT),'cells',ly.cells(),'top bbox',top.bbox())
