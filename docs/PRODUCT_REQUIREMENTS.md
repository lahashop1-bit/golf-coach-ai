# Product Requirements Document (PRD)

## 1. Tầm nhìn

Xây dựng một huấn luyện viên golf cá nhân trên iPhone. Người chơi quay video cú đánh, nhận phản hồi dễ hiểu, biết một hoặc hai điểm cần sửa và có bài tập phù hợp để luyện tập. Sản phẩm ưu tiên người mới và tiếng Việt tự nhiên, đồng thời phục vụ người dùng tiếng Anh và tiếng Hàn.

## 2. Vấn đề người dùng

Người mới thường:
- Không biết mình đang mắc lỗi gì.
- Nghe nhiều thuật ngữ tiếng Anh nhưng khó hiểu.
- Nhận quá nhiều lời khuyên cùng lúc, không biết sửa lỗi nào trước.
- Không biết đặt điện thoại ở đâu để quay đúng góc.
- Không theo dõi được liệu mình có tiến bộ hay không.
- Có thể hiểu nhầm phân tích tự động là kết luận chính xác tuyệt đối.

## 3. Nhóm người dùng

### Primary
Người mới chơi golf, tự luyện tại sân tập, cần chỉ dẫn từng bước, không có huấn luyện viên bên cạnh mọi buổi.

### Secondary
Người chơi trung cấp muốn ghi lại swing, so sánh theo thời gian và tập trung sửa một lỗi cụ thể.

### Hồ sơ onboarding
- Tay thuận: phải / trái.
- Trình độ: mới bắt đầu / cơ bản / trung cấp / nâng cao.
- Gậy thường tập: gậy sắt 7, các gậy sắt khác, hybrid, driver, wedge, putter.
- Mục tiêu: tiếp xúc bóng, hướng bóng, khoảng cách, nhịp swing, tính ổn định, hiểu kỹ thuật.
- Ngôn ngữ và đơn vị đo.

Không bắt buộc người dùng khai báo mọi thông tin để sử dụng tính năng quay video.

## 4. Nguyên tắc trải nghiệm

1. Một lần chỉ ưu tiên 1–2 lỗi quan trọng.
2. Nói rõ “AI quan sát thấy gì”, “có thể vì sao”, “hãy thử làm gì”.
3. Phân biệt quan sát từ video với suy luận.
4. Cho phép người dùng bỏ qua lời khuyên hoặc đánh dấu không phù hợp.
5. Không xấu hổ hóa người học; khích lệ nhưng không tâng bốc giả tạo.
6. Từ ngữ tiếng Việt tự nhiên và nhất quán.
7. Có thể xem thuật ngữ tiếng Anh khi người dùng muốn học thêm.

## 5. Phạm vi MVP

### Must have
- Onboarding: ngôn ngữ, tay thuận, trình độ, mục tiêu.
- Trang chủ và hồ sơ người chơi.
- Hướng dẫn quay video Face-on và Down-the-line (DTL).
- Ghi hình bằng camera iPhone, xem lại, quay lại, lưu hoặc xóa.
- Chọn loại gậy và tay thuận.
- Chọn chế độ tự quay hoặc phiên phân tích có hướng dẫn.
- Danh sách các video swing và chi tiết từng video.
- Phân tích tư thế cơ thể ở mức có thể đo được từ video, có cảnh báo chất lượng.
- Báo cáo dễ hiểu, chỉ ra độ tin cậy và giới hạn.
- Bài tập sửa lỗi có bước thực hiện, số lần và cách tự kiểm tra.
- Lịch sử buổi tập và ghi chú.
- Localization vi-VN, en, ko-KR.
- Quyền riêng tư, xóa video và xuất dữ liệu cơ bản.

### Should have
- Phân tích nhiều cú trong một phiên.
- Phản hồi ngay sau từng cú hoặc tổng kết sau phiên.
- So sánh hai video cạnh nhau.
- Nhắc lại bài tập và mục tiêu tuần.
- Hỗ trợ import video từ Photos.
- Tùy chỉnh FPS/timer nếu thiết bị hỗ trợ.
- Báo cáo tiến bộ theo tuần.

### Not in initial MVP
- Đo chính xác tốc độ đầu gậy, tốc độ bóng, spin, launch angle nếu không có phần cứng/camera chuyên dụng.
- Phân tích 3D toàn thân chính xác như hệ thống motion capture.
- Chẩn đoán y khoa/chấn thương.
- Mạng xã hội, bảng xếp hạng, marketplace.
- Đồng bộ thiết bị golf bên thứ ba trước khi có nhu cầu rõ ràng.

## 6. Các chỉ số thành công

- Người mới hoàn tất onboarding và quay được video đầu tiên.
- Tỷ lệ video đạt chất lượng đủ để phân tích.
- Tỷ lệ người dùng hiểu và hoàn thành bài tập đề xuất.
- Tỷ lệ quay lại luyện tập sau 7 ngày.
- Đánh giá mức dễ hiểu của tiếng Việt.
- Tỷ lệ phản hồi “không hiểu” hoặc “không phù hợp” ở nội dung AI.
- Crash-free sessions và thời gian xử lý video.

Không tối ưu chỉ số bằng cách khuyến khích người dùng tập quá sức hoặc mua gói trả phí không cần thiết.

## 7. Mô hình thương mại

Chưa quyết định. Thiết kế hệ thống có thể hỗ trợ:
- Miễn phí: ghi hình, lưu một số video, hướng dẫn cơ bản.
- Premium: phân tích AI nâng cao, lịch sử dài hạn, chương trình tập cá nhân.
- Không chặn các tính năng an toàn hoặc quyền xuất/xóa dữ liệu sau paywall.

Mọi giá, gói và entitlement phải được cấu hình từ backend/App Store, không hard-code.

## 8. Rủi ro và giả định

- Video 2D có giới hạn quan sát chiều sâu và khớp bị che khuất.
- Chất lượng phân tích phụ thuộc ánh sáng, góc máy, tốc độ màn trập, quần áo và toàn thân trong khung.
- Một lỗi hình ảnh có thể có nhiều nguyên nhân; AI phải dùng ngôn ngữ xác suất.
- Cần xác minh tính khả thi và chi phí của pose estimation trên thiết bị trước khi chọn mô hình.
- Quyền sử dụng mô hình/dataset phải được kiểm tra trước khi đưa vào sản phẩm.
