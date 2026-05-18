; 두 셀 인스턴스 사이의 연결된 net 수 세기
procedure(countSignalsBetweenInsts(cellView inst1Name inst2Name)
  let((inst1 inst2 nets1 nets2 commonNets count)
    inst1 = dbFindAnyInstByName(cellView inst1Name)
    inst2 = dbFindAnyInstByName(cellView inst2Name)
    
    ; 각 인스턴스에 연결된 net 수집
    nets1 = setof(term inst1~>instTerms term~>net)
    nets2 = setof(term inst2~>instTerms term~>net)
    
    ; 공통 net (두 인스턴스를 모두 연결하는 signal) 찾기
    commonNets = intersection(nets1 nets2)
    count = length(commonNets)
    
    printf("Signals between %s and %s: %d\n" inst1Name inst2Name count)
    printf("Signal names:\n")
    foreach(net commonNets
      printf("  - %s\n" net~>name)
    )
    count
  )
)
