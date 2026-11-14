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

Các trạng thái:
- Không thể phân tích: video thiếu người chơi, quá tối, quá rung hoặc bị che khuất.
- Confidence thấp: hiển thị cảnh báo và không đưa ra kết luận kỹ thuật mạnh.
- Confidence vừa: dùng ngôn ngữ “có vẻ”, “có thể”.
- Confidence cao: vẫn nêu góc quay và điều kiện quan sát.

Không hiển thị con số confidence giả. Nếu có điểm số, phải được hiệu chuẩn và giải thích ý nghĩa.

## 5. Cấu trúc phản hồi

```json
{
  "status": "completed",
  "camera_angle": "face_on",
  "club": "iron_7",
  "quality": {
    "level": "good",
    "issues": []
  },
  "observations": [
    {
      "id": "early_head_lift",
      "title_key": "analysis.early_head_lift.title",
      "evidence": "Đầu và thân trên thay đổi vị trí trước thời điểm tiếp xúc bóng.",
      "confidence": "medium",
      "phase": "downswing"
    }
  ],
  "priority_focus_id": "early_head_lift",
  "drill_ids": ["half_swing_posture"],
  "limitations": ["Một góc quay 2D không thể xác nhận toàn bộ chuyển động 3D."]
}
```

JSON trên là ví dụ schema, không phải kết quả đo thật.

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
