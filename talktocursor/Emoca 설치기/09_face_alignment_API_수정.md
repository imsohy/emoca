# 9단계: face_alignment API 수정

## 작업 완료 시간
2025년 2월 26일

## 수정 내용

### 문제
face_alignment 라이브러리의 API가 변경되어 `LandmarksType._2D`가 더 이상 사용되지 않음

### 수정 파일
- **파일**: `gdl/utils/FaceDetector.py`
- **라인**: 84번째 줄
- **수정 전**: `face_alignment.LandmarksType._2D`
- **수정 후**: `face_alignment.LandmarksType.TWO_D`

### 수정된 코드
```python
# 수정 전
self.model = face_alignment.FaceAlignment(face_alignment.LandmarksType._2D,
                                          device=str(device),
                                          flip_input=self.flip_input,
                                          face_detector=self.face_detector,
                                          face_detector_kwargs=self.face_detector_kwargs)

# 수정 후
self.model = face_alignment.FaceAlignment(face_alignment.LandmarksType.TWO_D,
                                          device=str(device),
                                          flip_input=self.flip_input,
                                          face_detector=self.face_detector,
                                          face_detector_kwargs=self.face_detector_kwargs)
```

### 수정 확인
```bash
conda activate work38_cu11
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

grep -n "LandmarksType" gdl/utils/FaceDetector.py
# 84번째 줄에 LandmarksType.TWO_D가 있어야 함

python -c "from gdl.utils.FaceDetector import FAN; import face_alignment; print(f'face_alignment LandmarksType.TWO_D: {face_alignment.LandmarksType.TWO_D}'); print('✅ face_alignment API 수정 확인 완료!')"
```

**결과:**
```
✅ face_alignment API 수정 확인 완료!
```

## 참고
- 이 수정은 INSTALLATION_TROUBLESHOOTING.md의 "문제 11"에 문서화되어 있음
- face_alignment 1.3.6 버전에서 API가 변경됨

## 다음 단계
10단계: 설치 검증

