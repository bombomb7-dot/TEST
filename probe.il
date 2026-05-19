cv = geGetWindowCellView()

; 모든 net의 속성 덤프
foreach(net cv~>nets
  printf("net: %s  props: %L\n" net~>name net~>??)
)

; schematic 내 모든 object 중 probe 관련 찾기
foreach(obj cv~>contents
  if(obj~>objType == "marker" then
    printf("marker type: %s  on: %L\n" obj~>type obj~>net)
  )
)