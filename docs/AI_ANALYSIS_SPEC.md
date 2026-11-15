# AI Swing Analysis Specification

## 1. Mục tiêu

Phân tích video swing để cung cấp phản hồi có căn cứ, dễ hiểu và có giới hạn rõ ràng. AI là công cụ hỗ trợ luyện tập, không thay thế huấn luyện viên trực tiếp.

## 2. Pipeline đề xuất

1. Kiểm tra định dạng, độ phân giải, FPS và thời lượng.
2. Kiểm tra chất lượng: đủ sáng, toàn thân trong khung, không rung mạnh, không bị che khuất nghiêm trọng.
3. Xác định người chơi và vùng cơ thể.
4. Ước lượng pose/keypoints bằng mô hình được cấp phép.
5. Làm mượt chuỗi keypoints theo thời gian, giữ lại confidence.
6. Ước lượng các pha swing nếu đủ tín hiệu.
7. Tính các đặc trưng hình học có thể suy ra từ góc quay.
8. Chạy rule/model phân loại lỗi với confidence và điều kiện áp dụng.
9. Tạo phản hồi có cấu trúc.
10. Chọn drill đã được biên soạn/duyệt, không để LLM tự sáng tác bài tập không kiểm soát.

## 3. Không được suy diễn quá mức

Video 2D không đủ để đo chính xác mọi chuyển động 3D. Không khẳng định chính xác:
- Góc xoay hông/vai 3D nếu chỉ có một góc 2D.
- Phân bổ áp lực chân trái/phải nếu không có cảm biến phù hợp.
- Tốc độ đầu gậy, tốc độ bóng, spin hoặc carry distance nếu không có thiết bị/nguồn đo.
- Góc mặt gậy tại impact nếu không quan sát được.
- Chẩn đoán y khoa hoặc nguyên nhân đau.

## 4. Chất lượng và confidence

Chất lượng video (`QualityLevel`):
- `poor` — không thể phân tích: thiếu người chơi, quá tối, quá rung hoặc bị che khuất. Nêu lý do và hướng dẫn quay lại; không tạo nhận xét kỹ thuật.
- `fair` — phân tích được nhưng có hạn chế; hiển thị cảnh báo chất lượng cùng kết quả.
- `good` — vẫn nêu góc quay và điều kiện quan sát.

Confidence của từng nhận xét:
- `low` — **không hiển thị như lỗi**. Lưu với cờ ẩn để đánh giá model; nếu một pha chỉ có dữ liệu low thì pha đó hiển thị "Chưa đủ dữ liệu".
- `medium` — hiển thị, dùng ngôn ngữ "có vẻ", "có thể".
- `high` — hiển thị, vẫn kèm giới hạn.

Không hiển thị con số confidence hay phần trăm chính xác. Không có điểm số tổng hợp ở MVP.

## 5. Mức (Level) — định nghĩa chuẩn

| Level | Nhãn vi-VN | Ý nghĩa |
|---|---|---|
| `ok` | Ổn | Đã kiểm tra được ở pha này, không thấy dấu hiệu lỗi |
| `attention` | Nên chú ý | Có dấu hiệu nhẹ, hoặc chỉ xuất hiện ở một số cú |
| `review` | Cần xem lại | Dấu hiệu rõ hoặc lặp lại; ứng viên ưu tiên sửa |
| `insufficient_data` | Chưa đủ dữ liệu | Không đủ bằng chứng (góc quay không phù hợp, che khuất, confidence thấp) |

Thứ tự nghiêm trọng: `review` > `attention` > `ok`. `insufficient_data` không phải mức nghiêm trọng, chỉ dùng cho pha/lỗi không đánh giá được. Mức hiển thị bằng chữ + biểu tượng, không chỉ màu.

Cấu trúc kết quả: xem mục 9.

## 6. Vai trò của LLM

LLM có thể:
- Diễn giải kết quả phân tích đã cấu trúc.
- Chuyển nội dung sang tiếng Việt tự nhiên, tiếng Anh hoặc tiếng Hàn.
- Điều chỉnh độ sâu theo trình độ.
- Trả lời câu hỏi dựa trên kết quả và thư viện bài tập đã duyệt.

LLM không được:
- Tự bịa keypoints hoặc số đo.
- Tự khẳng định lỗi khi vision model không cung cấp bằng chứng.
- Bịa nguồn chuyên môn.
- Tự đề xuất bài tập chưa có trong thư viện đã duyệt nếu nội dung có rủi ro kỹ thuật.

## 7. Human review và đánh giá chất lượng

Trước phát hành:
- Tạo tập video thử nghiệm có sự đồng ý và quyền sử dụng.
- Bao gồm nhiều vóc dáng, giới tính, trang phục, ánh sáng và tay thuận.
- Có golfer/HLV đủ chuyên môn gán nhãn.
- Đánh giá false positive/false negative theo từng góc quay.
- Kiểm tra riêng các lỗi có thể gây hiểu sai hoặc tập sai.
- Có cơ chế báo cáo kết quả không phù hợp.

## 8. Bảo mật video

- Xử lý trên thiết bị nếu khả thi.
- Nếu cần cloud, xin đồng ý riêng và giải thích nhà cung cấp, mục đích, thời hạn lưu.
- Mã hóa khi truyền và lưu.
- Không dùng video để huấn luyện model nếu chưa có opt-in rõ ràng.
- Cho phép xóa video và kết quả liên quan.

## 9. Schema kết quả cho MVP (v1, ví dụ)

Ví dụ cấu trúc, không phải kết quả đo thật.

```json
{
  "schema_version": "1.0",
  "model_version": "<chưa có>",
  "status": "completed",
  "camera_angle": "down_the_line",
  "club_type": "iron",
  "club_number": 7,
  "handedness": "right",
  "quality": { "level": "good", "issues": [] },
  "phases": [
    { "phase": "address", "timestamp_ms": 0, "confidence": "high" },
    { "phase": "top", "timestamp_ms": 1480, "confidence": "medium" },
    { "phase": "impact", "timestamp_ms": 2310, "confidence": "medium" }
  ],
  "tempo": {
    "backswing_ms": 1480, "top_pause_ms": 120, "downswing_ms": 710,
    "ratio": 2.1, "confidence": "medium"
  },
  "observations": [
    {
      "issue_id": "spine_angle_loss_top",
      "phase": "top",
      "level": "attention",
      "confidence": "medium",
      "camera_angle": "down_the_line",
      "evidence_key": "issue.spine_angle_loss_top.what_we_see",
      "evidence_frame_ms": 1480,
      "is_priority_focus": true
    }
  ],
  "phase_flow": [
    { "phase": "address", "level": "ok" },
    { "phase": "top", "level": "attention" },
    { "phase": "impact", "level": "insufficient_data" }
  ],
  "drill_ids": ["half_swing_posture"],
  "limitations": ["analysis.limit.single_2d_view"]
}
```

Quy tắc:
- Tên trường JSON là snake_case của các trường trong [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md); enum theo bảng enum chuẩn ở đó.
- `observations[].level` ∈ `ok` | `attention` | `review`; `phase_flow[].level` có thêm `insufficient_data`. Định nghĩa ở mục 5. Không dùng điểm số.
- Chỉ trả về observation có confidence `medium`/`high`; observation `low` được ghi riêng cho đánh giá, không hiển thị.
- `tempo` và `phases` chỉ có khi đo được.
- `is_priority_focus` do luật chọn (mục 11), không do LLM.
- Mọi `*_key` trỏ tới nội dung đã biên tập theo locale.

## 10. Bộ lỗi và mức sẵn sàng

Tên tiếng Việt theo [VIETNAMESE_GOLF_GLOSSARY.md](VIETNAMESE_GOLF_GLOSSARY.md) (bản nháp, chờ HLV duyệt).

Danh mục lỗi chia theo mức sẵn sàng. **Chưa có lỗi nào được xem là bật cho người dùng cuối** cho tới khi qua đánh giá (ACCEPTANCE_CRITERIA mục 8). Mức khả thi dưới đây là giả thuyết cần Phase 3 kiểm chứng, chưa đo.

### Nhóm A — Ứng viên ra mắt (khả thi trung bình)
| issue_id | Tên thân thiện | Góc phù hợp |
|---|---|---|
| head_lift_at_impact | Ngẩng đầu lúc tiếp xúc bóng | Face-on, DTL |
| spine_angle_loss_top | Mất góc cúi lưng ở đỉnh swing | DTL (tốt hơn), Face-on |
| early_extension | Đứng thẳng người quá sớm | DTL |
| hanging_back_impact | Dồn người lại phía sau lúc tiếp xúc | Face-on |

Nhịp swing không nằm trong danh mục lỗi: đây là **số đo** (mục 12), hiển thị ở tab Nhịp.

### Nhóm B — Sau khi kiểm chứng
| issue_id | Tên thân thiện | Ghi chú khả thi |
|---|---|---|
| lifting_upper_body_address | Nâng thân trên khi vào bóng | Trung bình, tư thế tĩnh |
| shoulder_up_impact | Vai nâng lên lúc tiếp xúc | Thấp–trung bình |
| side_bending_lack_impact | Thiếu nghiêng thân sang bên | Thấp–trung bình |
| pelvic_rotation_lack_impact | Hông xoay chưa đủ | Thấp (xoay 3D từ 2D) |
| left_arm_bend_top | Tay trái co ở đỉnh swing | Trung bình ở Face-on |
| club_inside_takeaway | Gậy đi vào trong lúc khởi động | Thấp–trung bình, cần DTL |
| over_the_top | Đưa gậy từ ngoài vào | Cần DTL, thấy gậy |

### Nhóm C — Chưa nên tự động hóa (khó đo từ video 2D)
early_wrist_hinge, unfolded_wrist_address, scooping_impact, chicken_wing. Có thể chỉ hiển thị như nội dung giáo dục hoặc để người dùng tự đánh dấu, cho tới khi có bằng chứng đo được.

### Phương pháp nhận diện
- Ưu tiên **luật hình học trên keypoints đã làm mượt**, có điều kiện áp dụng (góc quay, pha, độ tin cậy keypoint), vì dễ giải thích và kiểm tra.
- Mô hình học máy chỉ dùng khi luật không đủ và có dữ liệu gán nhãn.
- Mỗi lỗi có tài liệu mô tả: định nghĩa, tín hiệu đo, điều kiện áp dụng, ngưỡng (do Phase 3 xác định), trường hợp thường nhầm.
- Chưa đặt số ngưỡng trong tài liệu này vì chưa có dữ liệu.

### 10a. Luật nhóm A (hiện thực v0, lát 2b — ngưỡng TẠM)

Trong `packages/analysis_core` (`IssueDetector`). Keypoints đã lật cho người thuận tay trái. Khoảng cách tính theo chiều dài thân (vai → hông) lúc vào bóng, trung bình ±2 khung quanh mốc pha.

| issue_id | Góc | Số đo | Nên chú ý | Cần xem lại |
|---|---|---|---|---|
| head_lift_at_impact | cả hai | đầu (mũi + tai) nâng lên từ vào bóng → tiếp xúc | ≥ 0,08 thân | ≥ 0,15 thân |
| spine_angle_loss_top | DTL | độ nghiêng thân (hông → vai) giảm từ vào bóng → đỉnh | ≥ 7° | ≥ 13° |
| early_extension | DTL | hông tiến về phía bóng từ vào bóng → tiếp xúc | ≥ 0,07 thân | ≥ 0,14 thân |
| hanging_back_impact | Chính diện | hông dịch về phía mục tiêu từ vào bóng → tiếp xúc, theo độ rộng chân | < 0,08 chân | ≤ 0 |

- Hướng mặt (DTL) suy từ vị trí tay so với hông lúc vào bóng; hướng mục tiêu (chính diện) suy từ hông trái/phải. Không giả định người chơi đứng bên nào của khung hình.
- **Kiểm tra góc quay:** độ rộng vai / chiều dài thân lúc vào bóng ≥ 0,45 → giống chính diện, nhỏ hơn → giống DTL. Nếu không khớp góc đã chọn, bỏ các luật riêng theo góc và thêm giới hạn `analysis.limit.angle_mismatch`.
- **Confidence** = min(mốc pha, visibility các điểm dùng: ≥ 0,7 high, ≥ 0,5 medium) và **tối đa medium** cho tới khi ngưỡng được kiểm chứng. Low → lưu ẩn.
- Mỗi luật lưu `metricValue` để Phase 3 chỉnh ngưỡng trên video gán nhãn.
- Các ngưỡng trên **chưa có dữ liệu chứng minh**. Chỉ hiển thị ở bản nội bộ (cờ `EXPERIMENTAL_ISSUES`), có nhãn thử nghiệm.
- Đã thử trên 1 clip DTL thật (golfer giỏi): cả 3 luật DTL "Ổn" (đầu −0,09 thân, mất góc 3,5°, hông 0,04 thân). Một clip góc chéo sau lưng bị nhận đúng là không khớp chính diện.
- Giới hạn đã biết: hông xoay mở ở tiếp xúc làm điểm giữa hông dịch trong ảnh 2D; vai xoay ở đỉnh làm đổi độ nghiêng nhìn thấy; quần áo rộng làm lệch điểm hông.

## 11. Chọn lỗi ưu tiên và tổng hợp theo phiên

- Mỗi cú có thể có nhiều quan sát; chỉ hiển thị nổi bật **1–2 lỗi ưu tiên**, phần còn lại trong "Xem thêm".
- Chỉ đưa lên kết quả lỗi có confidence ≥ vừa và chất lượng video ≥ trung bình. Lỗi confidence thấp không hiển thị như lỗi; tối đa ghi "chưa đủ dữ liệu".
- Tổng hợp phiên: đếm số cú có mỗi lỗi ("Lặp lại nhiều nhất").
- Lỗi ưu tiên = kết hợp (a) lặp lại ở nhiều cú trong phiên, (b) `editorialPriority` do biên tập viên gán trong IssueGuide (nền tảng/tư thế trước, kết quả sau), (c) mức tin cậy. Công thức cụ thể do Phase 4 quyết định và ghi lại; không dùng LLM để chọn.
- Hiện thực v0 (`FocusSelector`): chỉ xét nhận xét hiển thị được ở mức `attention`/`review`; sắp theo mức (`review` trước) → số cú lặp lại → `editorialPriority` → confidence; lấy tối đa 2. Hiện chỉ chạy trong một cú (lặp lại = 1); tổng hợp phiên chưa làm.
- Chỉ xem là "tiến bộ" khi có đủ số cú cùng góc/gậy; không kết luận từ một cú.

## 11b. Nhận diện pha (hiện thực v2)

Trong `packages/analysis_core` (PhaseDetector):
- **Tín hiệu:** vị trí tay = trung bình có trọng số theo visibility của hai cổ tay. Hai tay cùng nắm cán gậy nên một cổ tay thường bị che, và tay vung nhanh thì bị nhòe. Tốc độ tay chia cho chiều dài thân (vai → hông) của chính khung đó (làm mượt ~0,25 giây), vì người chơi hay đi lại gần điện thoại trước và sau cú swing; tín hiệu được làm mượt nhẹ.
- **Chọn cú swing:** thử các đỉnh tốc độ tay từ nhanh đến chậm (cách nhau ≥ 0,6 giây, ≥ 40% đỉnh nhanh nhất); lấy đỉnh đầu tiên mà tay hạ từ đỉnh xuống tiếp xúc ít nhất 0,6 chiều dài thân và qua các giới hạn hợp lý bên dưới.
- **Tiếp xúc:** điểm tay thấp nhất, gần đỉnh tốc độ đã chọn.
- **Đỉnh:** điểm tay cao nhất trước đó.
- **Khởi động:** lúc kết thúc quãng đứng yên trước đỉnh.
- **Kết thúc:** lúc tay dừng lại (hoặc cao nhất) sau tiếp xúc.
- **Pha giữa:** mức tay ở giữa hai mốc kề nhau.
- **Giới hạn hợp lý** (để loại clip không phải một cú swing đủ): đưa gậy lên 0,3–2,5 giây, hạ gậy 0,1–0,9 giây. Đây là giới hạn xử lý tín hiệu, không phải ngưỡng lỗi.
- **Confidence:** theo visibility quanh mốc và FPS. Mốc cần thời gian chính xác: FPS dưới 25 → low, dưới 50 → tối đa medium.
- **Giới hạn đã biết:** mốc khởi động có thể trễ vài chục ms khi người chơi bắt đầu rất chậm. Mốc kết thúc có thể trễ khi tay ở sau đầu (visibility thấp) rồi người chơi đi về phía điện thoại. Video slow-motion phải giữ đúng timestamp thật.

## 12. Đo nhịp

- Mốc: khởi động đưa gậy → đỉnh → tiếp xúc.
- Đưa ra: thời gian đưa lên, dừng ở đỉnh, hạ gậy, tỷ lệ nhịp.
- Ghi chú trên UI: "ước tính từ video"; sai số phụ thuộc FPS và chất lượng mốc pha.
- Hiển thị khoảng tham khảo chỉ khi có nguồn đã duyệt; không so với pro nếu chưa có giấy phép.
- Với nhịp, dùng ngôn ngữ mô tả ("nhịp đưa lên khá chậm so với hạ gậy"), không phán xét.

## 13. Quy tắc nội dung hướng dẫn sửa

- Mỗi lỗi → một IssueGuide đã duyệt (xem DATABASE_SCHEMA mục 7).
- Khóa nội dung: `issue.<issue_id>.*` (xem I18N mục 8).
- Phản hồi gồm: điều quan sát thấy, vì sao có thể quan trọng, một điều nên thử, cảm giác cần tìm, cách tự kiểm tra.
- Bài tập chỉ lấy từ thư viện đã duyệt.
- Ghi rõ góc quay nên dùng nếu góc hiện tại kém tin cậy cho lỗi đó ("Lỗi này thường rõ hơn ở góc DTL").
- Không hứa chính xác tuyệt đối; luôn có phần giới hạn.

## 14. Xử lý và hiệu năng

- Phân tích trên máy (iOS và Android), ở nền; có thể hủy; hiển thị tiến trình.
- **Người thuận tay trái:** lật ngang keypoints trước khi chạy luật, để mọi luật viết cho người thuận tay phải; ghi `mirrored = true`; lật lại khi vẽ lớp phủ.
- Cùng model pose và cùng logic Dart trên hai nền tảng; kết quả phải nhất quán (xem PLATFORM_DECISION).
- Ghi FPS thật của video; FPS thấp (thường gặp trên Android tầm trung) làm giảm confidence của mốc pha và nhịp.
- Không chặn main thread; kiểm soát nhiệt và pin; giới hạn thời lượng video.
- Khi thiết bị không đủ khả năng: báo rõ, cho phép lưu video và phân tích sau.
- Giữ keypoints dẫn xuất ngoài DB; xóa cùng video.
