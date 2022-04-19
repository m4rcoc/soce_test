import os,sys
sys.argv[1]
f=open(sys.argv[1])
fichero=f.read()
f.close()
pos_em=fichero.index("MAC_src")

esta=0
i=0
while esta==0:
    if(fichero[pos_em+i]=="\n"):
        pos_fin=pos_em+i
        esta=1
    else:
        i=i+1

interface_vieja=fichero[pos_em:pos_fin]        
fichero=fichero.replace(interface_vieja,"MAC_src               ="+sys.argv[2])
f=open(sys.argv[1], "w")
f.write(fichero)
f.close()