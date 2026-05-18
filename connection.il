procedure(countSignalsBetweenInsts(cellView inst1Name inst2Name)
  let((inst1 inst2 netNames1 netNames2 commonNames count)
    inst1 = dbFindAnyInstByName(cellView inst1Name)
    inst2 = dbFindAnyInstByName(cellView inst2Name)

    ; net 객체 대신 net 이름(string)으로 수집
    netNames1 = setof(name
                  mapcar(lambda((term) term~>net~>name) inst1~>instTerms)
                  name != nil)

    netNames2 = setof(name
                  mapcar(lambda((term) term~>net~>name) inst2~>instTerms)
                  name != nil)

    printf("nets of %s: %L\n" inst1Name netNames1)
    printf("nets of %s: %L\n" inst2Name netNames2)

    ; 이름 기반으로 공통 net 찾기
    commonNames = setof(name netNames1 member(name netNames2))

    count = length(commonNames)
    printf("Common signals: %d\n" count)
    printf("Signal names:\n")
    foreach(name commonNames
      printf("  - %s\n" name)
    )
    count
  )
)



; 현재 열린 schematic의 cellView 가져오기
; cv = geGetWindowCellView()
; countSignalsBetweenInsts(cv "U1" "U2")
