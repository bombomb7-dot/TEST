cv = geGetWindowCellView()
net1 = car(cv~>nets)
printf("net name: %s\n" net1~>name)

; 방법 1
printf("objType: %s\n" net1~>objType)

; 방법 2 - SKILL의 일반적인 속성 조회
inspect(net1)

; 현재 선택된 object 속성 확인
sel = car(hiGetCurrentSelection(cv))
printf("selected obj type: %s\n" sel~>objType)
printf("selected obj attrs: %L\n" dbGetAttributeList(sel))

; 단일 net select 테스트
cv = geGetWindowCellView()
net1 = car(cv~>nets)
hiSelectObject(net1)
printf("test select: %s\n" net1~>name)