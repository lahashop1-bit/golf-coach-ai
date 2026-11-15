# Acceptance Criteria

## 1. Onboarding
- Người dùng có thể chọn vi-VN, en hoặc ko-KR.
- Có thể đổi ngôn ngữ sau onboarding.
- Chọn tay thuận và trình độ.
- Không bắt buộc hoàn thành trường không thiết yếu.
- Văn bản không bị cắt ở cỡ chữ hệ thống lớn trên iOS và Android.

## 2. Camera setup
- Có giải thích dễ hiểu cho Face-on và DTL.
- Hình hướng dẫn chỉ rõ người chơi, bóng, mục tiêu và tripod.
- Người dùng chọn được loại gậy và tay thuận.
- FPS chỉ hiển thị tùy chọn thiết bị hỗ trợ.
- Có thông báo nếu chưa cấp quyền camera.
- Có cảnh báo vị trí tripod an toàn.

## 3. Recording
- Có thể bắt đầu và dừng quay.
- Có trạng thái đang quay rõ ràng.
- Có thể xem lại video.
- Có thể quay lại, lưu hoặc xóa.
- Xử lý được camera interruption và app background.
- Video không tự upload nếu chưa có consent.

## 4. Analysis
- Mỗi kết quả gắn modelVersion và schemaVersion.
- Video không đủ chất lượng không tạo kết luận kỹ thuật mạnh.
- Mỗi nhận xét có bằng chứng, confidence và giới hạn.
- Không hiển thị số liệu không đo được.
- Có trạng thái processing, completed, insufficient quality và failed.

## 5. Coaching content
- Mỗi drill có mục tiêu, chuẩn bị, bước thực hiện, số lần, cảm giác, lỗi thường gặp và cách tự kiểm tra.
- Nội dung beginner dùng câu ngắn và dễ hiểu.
- Có cảnh báo dừng nếu đau/khó chịu.
- Drill kỹ thuật phải được review trước khi xuất bản.

## 6. Localization
- Không còn chuỗi UI hard-code trong code Flutter hoặc native.
- Các màn hình MVP có vi-VN, en, ko-KR.
- Tiếng Việt được biên tập, không chỉ machine translate.
- Đổi locale không làm mất dữ liệu.
- Ngày giờ và số được format đúng locale.
- Có fallback khi thiếu bản dịch.

## 7. Privacy
- Có giải thích trước khi upload video.
- Người dùng có thể xóa video và dữ liệu liên quan.
- Không có secrets trong source control.
- Video và API được bảo vệ bằng cơ chế xác thực/ủy quyền phù hợp.
- Có chính sách retention rõ ràng trước production.

## 8. Release gate
Không phát hành phân tích AI như tính năng thật cho tới khi:
- Model được đánh giá trên tập dữ liệu có quyền sử dụng.
- Có đánh giá chuyên môn.
- Đã đo false positives/false negatives.
- Các giới hạn được thể hiện trong UI.
- Có cơ chế báo lỗi và tắt tính năng nếu model gặp sự cố.

## 9. Nhập video và thu thập
- Nhập được video từ thư viện ảnh trên iOS và Android; bắt buộc chọn (hoặc xác nhận) góc quay, gậy, tay thuận, swing của ai.
- Hỗ trợ chọn "tập không gậy".
- Cú của người khác không tính vào thống kê mặc định; đổi được từng cú.
- Mỗi cú là một clip; có thể quay đủ số cú đã chọn hoặc kết thúc sớm.
- Xóa cú/phiên xóa đủ dữ liệu liên quan (DATABASE_SCHEMA mục 13).
- Nhóm cú theo phiên; lọc theo gậy, góc, ngày, lỗi.
- Yêu thích, ghi chú, công tắc "tính vào thống kê" hoạt động và được lưu.

## 10. Phân tích tư thế và cú swing (cốt lõi MVP)
- Kiểm tra chất lượng video (GOLF_FEATURES mục 2.4); thông báo rõ lý do và hướng dẫn quay lại khi không đạt.
- Phân tích chạy ở nền, có tiến trình, hủy được, không làm đơ giao diện.
- Pha swing chỉ hiển thị khi đủ confidence; người dùng chỉnh được mốc.
- Nhịp (đưa lên, dừng ở đỉnh, hạ gậy, tỷ lệ) có chú thích "ước tính từ video".
- Mỗi lỗi hiển thị: mức (AI spec mục 5), mức tin cậy bằng lời, góc áp dụng, bằng chứng, giới hạn.
- Chỉ lỗi đã qua đánh giá được bật trong bản công khai; lỗi chưa đạt chỉ có trong bản nội bộ với nhãn "thử nghiệm".
- Lỗi confidence thấp không hiển thị như lỗi; pha thiếu dữ liệu ghi "Chưa đủ dữ liệu".
- Tối đa 1–2 lỗi ưu tiên nổi bật; lỗi khác trong "Xem thêm".
- Không có điểm số x/10, x/100; không số liệu không đo được.
- Lớp phủ khung xương bật/tắt được; ẩn khi confidence thấp.
- Có cách báo "không hữu ích / không phù hợp" cho từng nhận xét.

## 11. Hướng dẫn sửa lỗi
- Mỗi lỗi bật có IssueGuide đã duyệt đủ: quan sát, vì sao quan trọng, một điều nên thử, cảm giác, cách tự kiểm tra, lỗi thường gặp.
- Mỗi lỗi liên kết ít nhất một bài tập đã duyệt; bài tập do thư viện, không do LLM sáng tác.
- Góc quay phù hợp hơn được gợi ý khi cần.
- Có cảnh báo dừng nếu đau/khó chịu.
- Tiếng Việt qua biên tập; thuật ngữ khớp glossary.

## 12. Theo dõi và so sánh
- So sánh chỉ cho phép hai cú cùng góc.
- "Cải thiện" chỉ hiển thị khi đủ số cú cùng góc/gậy; không kết luận từ một cú.
- Báo cáo ngày/tháng hiển thị số liệu đếm được, chỉ từ cú `includeInStats`; biểu đồ có mô tả văn bản.

## 13. Tính năng Should have (khi triển khai)
- Shot Fix: chỉ nội dung biên soạn, không suy ra đường bóng; có duyệt HLV.
- Mục tiêu ngày/tuần: do người dùng đặt, mặc định tắt, không phạt khi bỏ lỡ.

## 14. Trợ năng và trạng thái
- Mọi màn có loading, rỗng, lỗi, thành công và nhãn trợ năng (VoiceOver, TalkBack).
- Mức lỗi không chỉ dựa vào màu.
- Bản dịch vi/ko không bị cắt ở cỡ chữ hệ thống lớn (Dynamic Type / font scale).

## 15. Đa nền tảng (iOS và Android)
- Mọi luồng MVP chạy được trên iOS và Android với cùng tính năng.
- Cùng một video cho cùng kết quả phân tích (pha, nhịp, lỗi) trên hai nền tảng, trong sai số do FPS/giải mã đã ghi lại.
- Bộ video regression chạy được trên thiết bị thật của cả hai nền tảng.
- Quyền camera/thư viện ảnh xin đúng thời điểm, theo hộp thoại hệ thống của từng nền tảng; xử lý khi bị từ chối.
- Nút/cử chỉ Back Android và vuốt quay lại iOS hoạt động đúng, không làm mất dữ liệu đang quay.
- VoiceOver và TalkBack đọc được các nhãn chính; cỡ chữ lớn không làm vỡ giao diện.
- Phân tích hoàn thành trong giới hạn thời gian được đặt ở Phase 3 trên thiết bị thấp nhất của ma trận thử nghiệm mỗi nền tảng.
- Khai báo quyền riêng tư đầy đủ cho App Store và Google Play.
