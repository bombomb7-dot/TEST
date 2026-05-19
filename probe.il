cv = geGetWindowCellView()

; net의 실제 속성 이름 목록 확인
net1 = car(cv~>nets)
printf("net name: %s\n" net1~>name)
printf("net attributes: %L\n" dbGetAttributeList(net1))

; 현재 선택된 object 속성 확인
sel = car(hiGetCurrentSelection(cv))
printf("selected obj type: %s\n" sel~>objType)
printf("selected obj attrs: %L\n" dbGetAttributeList(sel))

; 단일 net select 테스트
cv = geGetWindowCellView()
net1 = car(cv~>nets)
hiSelectObject(net1)
printf("test select: %s\n" net1~>name)