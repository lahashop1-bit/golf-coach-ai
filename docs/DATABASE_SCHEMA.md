# Database Schema (Conceptual)

Schema khái niệm cho MVP. Chưa phải migration SQL cuối cùng.

## 1. UserProfile
- id: UUID
- preferredLocale: string (vi-VN, en, ko-KR)
- handedness: right | left
- skillLevel: beginner | basic | intermediate | advanced
- goals: string[]
- preferredUnits: metric | imperial
- createdAt, updatedAt

## 2. SwingSession
- id: UUID
- userId: UUID
- startedAt, endedAt
- clubType: driver | wood | hybrid | iron | wedge | putter
- clubNumber: optional integer (e.g. 7)
- cameraAngle: face_on | down_the_line | other
- handednessSnapshot: right | left
- plannedSwingCount: optional integer
- instantFeedbackEnabled: boolean
- status: draft | recording | review | completed | cancelled
- notes: optional string

## 3. SwingVideo
- id: UUID
- sessionId: UUID
- localAssetIdentifier: optional string
- remoteObjectKey: optional string
- durationMs: integer
- width, height: integer
- fps: optional number
- fileSizeBytes: integer
- uploadConsentAt: optional datetime
- uploadStatus: local_only | pending | uploaded | failed | deleted
- createdAt

## 4. SwingAnalysis
- id: UUID
- videoId: UUID
- modelVersion: string
- analysisSchemaVersion: string
- status: queued | processing | completed | insufficient_quality | failed
- qualityLevel: poor | fair | good
- observations: structured JSON
- priorityFocusId: optional string
- limitations: string[]
- createdAt, completedAt

## 5. Drill
- id: stable string
- category: string
- applicableSkillLevels: string[]
- applicableClubs: string[]
- applicableCameraAngles: string[]
- safetyNotes: localized structured content
- reviewedBy: optional string
- reviewedAt: optional datetime
- contentVersion: string

## 6. DrillLocaleContent
- drillId
- locale
- title
- goal
- equipment
- steps: structured array
- repetitions
- expectedFeel
- commonMistakes
- selfCheck
- safetyText

## 7. UserDrillLog
- id: UUID
- userId
- drillId
- completedAt
- perceivedDifficulty: optional 1–5
- helpfulness: optional helpful | unclear | not_relevant
- notes: optional string

## 8. Data rules

- Dùng UUID hoặc ID ổn định, không dùng email làm primary key.
- Tách video binary khỏi database.
- Local-only video không cần upload để có thể lưu session.
- Xóa video phải xử lý analysis và object storage theo policy.
- Không lưu thông tin nhạy cảm không cần thiết.
- Dùng migration có version và test rollback/backup strategy.
