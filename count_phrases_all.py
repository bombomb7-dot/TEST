```python
#!/usr/bin/env python3
# count_phrases_all.py

import os

def count_phrases_in_file(filepath: str, phrases: list[str]) -> dict[str, int] | None:
    """단일 파일에서 문구 개수를 세어 반환합니다."""
    results = {phrase: 0 for phrase in phrases}

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        try:
            with open(filepath, 'r', encoding='cp949') as f:
                content = f.read()
        except UnicodeDecodeError:
            try:
                with open(filepath, 'r', encoding='ascii') as f:
                    content = f.read()
            except Exception as e:
                print(f"  [오류] 파일 읽기 실패: {e}")
                return None
        except Exception as e:
            print(f"  [오류] {e}")
            return None
    except Exception as e:
        print(f"  [오류] {e}")
        return None

    for phrase in phrases:
        results[phrase] = content.count(phrase)

    return results


def analyze_folder(folder_path: str, phrases: list[str], extensions: list[str] = None):
    """
    폴더 내 모든 파일을 분석하여 문구 개수를 출력합니다.

    Args:
        folder_path : 분석할 폴더 경로
        phrases     : 찾을 문구 목록
        extensions  : 분석할 확장자 목록 (None이면 모든 파일)
    """
    if not os.path.isdir(folder_path):
        print(f"오류: '{folder_path}' 폴더를 찾을 수 없습니다.")
        return

    all_files = []
    for root, _, files in os.walk(folder_path):
        for fname in files:
            if extensions is None or any(fname.endswith(ext) for ext in extensions):
                all_files.append(os.path.join(root, fname))

    if not all_files:
        print("분석할 파일이 없습니다.")
        return

    print("=" * 60)
    print(f"  폴더  : {os.path.abspath(folder_path)}")
    print(f"  문구  : {phrases}")
    print(f"  파일수: {len(all_files)}개")
    print("=" * 60)

    total = {phrase: 0 for phrase in phrases}

    for filepath in sorted(all_files):
        rel_path = os.path.relpath(filepath, folder_path)
        counts = count_phrases_in_file(filepath, phrases)

        if counts is None:
            print(f"\n[SKIP] {rel_path}")
            continue

        print(f"\n📄 {rel_path}")
        for phrase, count in counts.items():
            print(f"    '{phrase}' : {count}개")
            total[phrase] += count

    print("\n" + "=" * 60)
    print("  📊 전체 합계")
    print("-" * 60)
    for phrase, count in total.items():
        print(f"    '{phrase}' : {count}개")
    print("=" * 60)


def main():
    # ── 설정 ──────────────────────────────────────────
    folder_path = "."                       # 분석할 폴더 경로
    phrases     = ["input", "output"]       # 찾을 문구 목록
    extensions  = [".pinlabellist"]         # 분석할 확장자
    # ─────────────────────────────────────────────────

    analyze_folder(folder_path, phrases, extensions)


if __name__ == "__main__":
    main()
```

`phrases`와 `folder_path`만 필요에 맞게 바꿔서 사용하시면 됩니다.