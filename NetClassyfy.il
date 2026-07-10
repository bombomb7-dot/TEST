**사용법**

CIW에서:
```
load("netClassify.il")
netClassify_run()
```
스키매틱 창을 미리 열어놓은 상태에서 실행하면 `~/netClassify_report.csv`로 결과가 떨어집니다. 경로 바꾸고 싶으면 `netClassify_run("/path/to/report.csv")`.

**코드 설명**

1. **`netClassify_getTerminals(net)`**
   `net~>terminals`를 순회하면서 각 terminal에 물려있는 `instTerms`(instance pin)를 뽑아 `(instName pinName)` 쌍 리스트로 반환합니다. 이게 그 net이 실제로 어느 instance의 어느 pin들을 연결하는지 알아내는 핵심 로직입니다.

2. **`netClassify_isHierCrossing(net)`**
   `net~>pins`는 그 net이 현재 cellview의 top-level I/O 심볼 핀에 물려있는지를 나타냅니다. non-nil이면 이 net이 상위 계층(또는 심볼 boundary)으로 나가는 net이라는 뜻 — 즉 Category A(hierarchy-crossing) 후보입니다.

3. **`netClassify_run()`** — 메인 로직
   - `hiGetCurrentWindow()`로 현재 열린 스키매틱 세션을 가져옵니다.
   - `cv~>nets`로 전체 net 리스트를 순회합니다 (271 instance 규모면 이 리스트가 500~800개쯤 될 겁니다).
   - 각 net마다:
     - fan-out(연결된 pin 개수) 계산
     - 계층 관통 여부 먼저 체크 → 맞으면 `A_hierCross`
     - 아니면 fan-out ≥ 3이면 `B_highFanout`
     - 나머지는 `C_local` (point-to-point)
   - 결과를 CSV로 저장: `NetName, FanOut, Category, ConnectedInstPins`

4. **CSV 형식이 중요한 이유**
   `ConnectedInstPins` 컬럼에 `U3.OUT;U7.IN;` 형태로 실제 연결 관계가 남기 때문에, Excel에서 필터링/정렬해서 category별로 몇 개인지 바로 파악되고, 이후 rename 룰 적용할 때도 이 컬럼을 소스로 삼아 새 이름을 자동 생성할 수 있습니다.

**다음 단계 제안**
1. 이 스크립트 먼저 돌려서 A/B/C 개수 파악
2. 결과 CSV 저를 통해 확인해 주시면, 그 다음 단계인 "**rename map 생성 스크립트**"(dry-run으로 old→new 이름 매핑만 CSV로 뽑는 것)를 이어서 짜드리겠습니다. 실제 `hiRenameNet` 반영은 그 다음 단계입니다.

CSV 나오면 카테고리별 개수 알려주세요 — 그거 보고 rename 룰 우선순위를 더 구체화할 수 있어요.