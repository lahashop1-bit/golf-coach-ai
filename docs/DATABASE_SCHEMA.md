# Database Schema (Conceptual)

Schema khái niệm cho MVP, là **nguồn chuẩn duy nhất cho tên entity, trường và enum**. Các tài liệu khác tham chiếu về đây. Chưa phải migration cuối cùng (sẽ hiện thực bằng drift/SQLite, xem [TECHNICAL_ARCHITECTURE.md](TECHNICAL_ARCHITECTURE.md)).

## 0. Quy ước

- Tên trường trong Dart/DB: `camelCase`. Trong JSON kết quả phân tích và file nội dung: `snake_case` (ví dụ `schemaVersion` ↔ `schema_version`).
- Giá trị enum: `snake_case`, tiếng Anh, ổn định; không đổi tên sau khi phát hành (thêm giá trị mới thì được).
- ID: UUID cho dữ liệu người dùng; ID chuỗi ổn định cho nội dung biên soạn (`head_lift_at_impact`, `half_swing_posture`).
- Thời gian: UTC trong DB, hiển thị theo locale.
- MVP **không có tài khoản**: một hồ sơ local duy nhất, `userId` là UUID sinh trên máy (để sau này đồng bộ không phải migrate).

## 1. Enum chuẩn

| Enum | Giá trị |
|---|---|
| Handedness | `right`, `left` |
| SkillLevel | `beginner`, `basic`, `intermediate`, `advanced` |
| Goal | `contact`, `direction`, `distance`, `tempo`, `consistency`, `technique` |
| ClubType | `driver`, `wood`, `hybrid`, `iron`, `wedge`, `putter`, `none` (tập không gậy) |
| CameraAngle | `face_on`, `down_the_line` |
| SessionMode | `guided_analysis`, `self_record` |
| Subject | `self`, `other` |
| Source | `recorded`, `imported` |
| Platform | `ios`, `android` |
| SwingPhase | `address`, `takeaway`, `backswing`, `top`, `downswing`, `impact`, `follow_through`, `finish` |
| QualityLevel | `poor`, `fair`, `good` |
| QualityIssue | `too_dark`, `not_full_body`, `shaky`, `occluded`, `too_short`, `low_fps` |
| AnalysisStatus | `queued`, `processing`, `completed`, `insufficient_quality`, `failed`, `cancelled` |
| Confidence | `low`, `medium`, `high` |
| Level | `ok`, `attention`, `review`, `insufficient_data` (định nghĩa ở [AI_ANALYSIS_SPEC.md](AI_ANALYSIS_SPEC.md) mục 5) |
| FeedbackValue | `helpful`, `unclear`, `not_relevant` |
| FeedbackTiming | `after_each`, `end_of_session` |

Gậy cụ thể = `clubType` + `clubNumber` (ví dụ gậy sắt số 7 = `iron` + `7`). Trong JSON: `"club_type": "iron", "club_number": 7`.

## 2. UserProfile
- id: UUID
- preferredLocale: `vi-VN` | `en` | `ko-KR`
- handedness: Handedness
- skillLevel: optional SkillLevel
- goals: Goal[]
- preferredClubType, preferredClubNumber: optional
- preferredUnits: `metric` | `imperial`
- createdAt, updatedAt

## 3. SwingSession (một lần mở camera/nhập, gồm 1..n cú)
- id, userId
- mode: SessionMode
- source: Source
- startedAt, endedAt
- clubType, clubNumber (optional)
- cameraAngle: CameraAngle
- handednessSnapshot: Handedness
- defaultSubject: Subject (giá trị mặc định cho các cú trong phiên)
- plannedSwingCount: optional integer (mặc định 3 khi `guided_analysis`)
- feedbackTiming: FeedbackTiming
- feedbackDisplaySeconds: optional integer
- timerSeconds: optional integer (0 = tắt)
- requestedFps: optional integer
- status: `draft` | `recording` | `review` | `completed` | `cancelled`
- note: optional string

## 4. Swing (một cú swing = một clip video)
- id, sessionId
- orderIndex: integer (thứ tự trong phiên)
- subject: Subject (mặc định lấy từ phiên, đổi được từng cú)
- includeInStats: boolean (mặc định `true` nếu subject = self, `false` nếu other)
- isFavorite: boolean
- note: optional string
- platform: Platform
- localFilePath: string (tương đối trong vùng lưu trữ app)
- sourceAssetId: optional string (PHAsset id / content URI khi nhập)
- thumbnailPath: optional string
- durationMs, width, height, fileSizeBytes
- actualFps: number (FPS thật đọc từ file — bắt buộc)
- rotationDegrees: integer
- qualityLevel: optional QualityLevel; qualityIssues: QualityIssue[]
- uploadConsentAt: optional; uploadStatus: `local_only` | `pending` | `uploaded` | `failed` | `deleted`
- createdAt

## 5. SwingAnalysis (một kết quả phân tích của một cú; có thể có nhiều bản theo model)
- id, swingId
- modelVersion, schemaVersion: string
- status: AnalysisStatus
- isCurrent: boolean (bản đang hiển thị)
- mirrored: boolean (true khi đã lật keypoints cho người thuận tay trái)
- keypointsFilePath: optional string (tệp dẫn xuất, định dạng ở mục 12)
- phases: [{ phase: SwingPhase, timestampMs, confidence: Confidence, userAdjusted: boolean }]
- tempo: optional { backswingMs, topPauseMs, downswingMs, ratio, confidence }
- limitationKeys: string[]
- createdAt, completedAt

Lỗi của cú **chỉ** lưu trong `IssueObservation` (không lưu thêm bản JSON trong SwingAnalysis).

## 6. IssueObservation
- id, analysisId
- issueId: string (theo danh mục ở AI_ANALYSIS_SPEC mục 10)
- phase: SwingPhase
- level: Level (`ok` | `attention` | `review`)
- confidence: Confidence (chỉ lưu `medium`/`high` để hiển thị; `low` lưu với cờ ẩn để đánh giá)
- hiddenFromUser: boolean
- cameraAngle: CameraAngle
- evidenceKey: string
- evidenceFrameMs: optional integer
- isPriorityFocus: boolean

## 7. Nội dung biên soạn (đóng gói trong app ở MVP)

Lưu dạng file JSON có version theo locale trong assets; nạp vào bảng chỉ đọc khi khởi động. Cập nhật qua phiên bản app (tải từ xa là việc sau MVP).

### IssueGuide
- issueId, locale, contentVersion
- title, whatWeSee, whyItMatters, feelToLookFor, oneThingToTry, selfCheck, commonMistakes
- correctionDifficulty: 1–3 (độ khó sửa **lỗi này**, do biên tập viên gán)
- preferredCameraAngle: optional CameraAngle
- applicableClubTypes: ClubType[]
- editorialPriority: integer (thứ tự ưu tiên sửa; nhỏ = nền tảng hơn)
- drillIds: string[]
- reviewedBy, reviewedAt

### Drill
- id, contentVersion, category
- issueIds: string[]
- applicableSkillLevels, applicableClubTypes, applicableCameraAngles
- supportsRepCounting: boolean (Phase 5)
- reviewedBy, reviewedAt

### DrillLocaleContent
- drillId, locale, title, goal, equipment, steps[], repetitions, expectedFeel, commonMistakes, selfCheck, safetyText

### ShotTroubleGuide (Should have)
- id, applicableClubTypes, causeKeys[], drillIds[], contentVersion, reviewedBy
- ShotTroubleLocaleContent: id, locale, title, description, causes[], questions[]

## 8. UserDrillLog
- id, userId, drillId
- completedAt
- repCount: optional integer
- linkedSwingIds: UUID[] (cú quay kiểm tra, optional)
- perceivedDifficulty: optional 1–5
- helpfulness: optional FeedbackValue
- note: optional string

## 9. AnalysisFeedback
- id, userId, observationId
- value: FeedbackValue
- comment: optional string
- createdAt

## 10. UserGoal (Should have, mặc định không có bản ghi nào)
- id, userId
- kind: `analysis_count` | `drill_count` | `tempo_practice`
- target: integer; period: `day` | `week`
- isActive: boolean; createdAt

## 11. Dữ liệu tính toán (không bắt buộc lưu)
- SessionSummary: sessionId, swingCount, issueCounts{issueId: n}, priorityIssueId, avgTempoRatio.
- DailySummary / MonthlySummary: date|month, clubTypeFilter, cùng các trường trên. Chỉ tính trên các cú `includeInStats = true`.

## 12. Tệp keypoints
- Một tệp nhị phân mỗi analysis: header (schema version, model, số khung, số điểm, fps), sau đó mỗi khung: timestampMs + (x, y, confidence) cho từng điểm, tọa độ chuẩn hóa 0–1. Định dạng chi tiết chốt ở Phase 3.
- Lưu cạnh video; xóa cùng video.

## 13. Quy tắc dữ liệu
- Không dùng email làm khóa chính; không lưu thông tin nhạy cảm không cần thiết.
- Video binary tách khỏi DB.
- **Xóa một cú** → xóa video, thumbnail, tệp keypoints, SwingAnalysis, IssueObservation, AnalysisFeedback liên quan. **Xóa phiên** → xóa mọi cú trong phiên. **Xóa toàn bộ dữ liệu** → xóa DB và thư mục video.
- **Xuất dữ liệu:** một file ZIP gồm JSON (hồ sơ, phiên, cú, kết quả, ghi chú) và video gốc tùy chọn.
- Migration có version; không mất dữ liệu người dùng; có test migration.
