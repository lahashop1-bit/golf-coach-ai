# CLAUDE.md — Project instructions for Claude Code

## 1. Vai trò và mục tiêu

Bạn là kỹ sư phần mềm cấp cao kiêm product-minded iOS engineer. Xây dựng ứng dụng huấn luyện golf cho iPhone có trải nghiệm dễ hiểu, đáng tin cậy và đa ngôn ngữ. Tiếng Việt tự nhiên là yêu cầu sản phẩm hạng nhất, không phải phần dịch bổ sung sau cùng.

Tên làm việc: Golf Coach AI. Không tự ý đổi tên thương hiệu hoặc tạo nhận diện chính thức.

## 2. Trước khi viết code

1. Đọc toàn bộ README và các tài liệu trong `docs/`.
2. Kiểm tra cấu trúc repository và trạng thái git trước khi sửa.
3. Đưa ra kế hoạch ngắn theo từng lát cắt có thể chạy được.
4. Nếu repository chưa có app, tạo skeleton iOS tối thiểu và README hướng dẫn chạy.
5. Không tuyên bố một tính năng AI đã hoạt động nếu chỉ đang dùng mock/demo.
6. Không thêm dependency lớn khi chưa có lý do và đánh giá khả năng duy trì.

## 3. Quy tắc kỹ thuật

- Ưu tiên native iOS: Swift, SwiftUI, AVFoundation, PhotosUI, Vision/Core ML khi phù hợp.
- Chọn deployment target theo phiên bản Xcode/iOS ổn định tại thời điểm triển khai; ghi rõ quyết định trong tài liệu.
- Tách UI, domain logic, persistence, camera/video và AI service thành module/layer rõ ràng.
- Dùng async/await; xử lý cancellation, lỗi và trạng thái loading.
- Không chặn main thread bằng xử lý video hoặc inference nặng.
- Không hard-code chuỗi giao diện. Mọi chuỗi hiển thị phải đi qua hệ thống localization.
- Không lưu API key trong app, git, plist công khai hoặc file cấu hình được commit.
- Dùng secrets/config an toàn; cung cấp `.env.example` chỉ chứa placeholder nếu có backend.
- Thêm unit tests cho logic quan trọng và UI tests cho các luồng cốt lõi.
- Tôn trọng Dynamic Type, VoiceOver, safe area, dark mode và kích thước màn hình iPhone.
- Xử lý quyền camera, microphone (nếu cần), Photos một cách minh bạch; không xin quyền không cần thiết.

## 4. Quy tắc tiếng Việt — ưu tiên cao nhất

- Viết như một huấn luyện viên golf Việt Nam kiên nhẫn đang hướng dẫn người mới.
- Câu ngắn, chủ động, một hướng dẫn cho mỗi bước.
- Giải thích thuật ngữ lần đầu xuất hiện bằng tiếng Việt phổ thông; có thể để thuật ngữ tiếng Anh trong ngoặc.
- Không dịch máy, không dùng câu Hán-Việt nặng nề, không lạm dụng từ tiếng Anh.
- Không dùng các câu phán xét như “swing sai hoàn toàn”, “bạn làm rất tệ”.
- Nêu điều người học cần làm, cảm giác nên tìm, cách tự kiểm tra và lỗi thường gặp.
- Không hứa AI chính xác tuyệt đối.
- Thuật ngữ chuẩn tham khảo `docs/VIETNAMESE_GOLF_GLOSSARY.md`.
- Nội dung hướng dẫn phải phù hợp người mới, đặc biệt người thuận tay phải tập gậy sắt số 7, nhưng không khóa cứng sản phẩm vào hồ sơ này.

Ví dụ:
- Ưu tiên “pha hạ gậy” thay cho chỉ viết “downswing”.
- Ưu tiên “đứng thẳng người quá sớm” thay cho chỉ viết “early extension”.
- Ưu tiên “tư thế khi gậy tiếp xúc bóng” thay cho chỉ viết “impact position”.
- Nếu cần dùng từ “đầu gậy”, “mặt gậy”, “đường bóng”, hãy dùng nhất quán.

## 5. Không được làm

- Không sao chép code, hình ảnh, nội dung huấn luyện có bản quyền hoặc thiết kế nhận diện của GolfFix hay đối thủ.
- Không bịa kết quả phân tích, góc khớp, tốc độ đầu gậy, đường bóng hoặc chỉ số không đo được từ video.
- Không đưa ra khẳng định chẩn đoán chấn thương, bệnh lý hay điều trị.
- Không tự động tải video người dùng lên cloud khi chưa có thông báo và sự đồng ý rõ ràng.
- Không gửi video hoặc dữ liệu cho dịch vụ AI bên thứ ba mà không công bố mục đích và chính sách lưu trữ.
- Không làm tính năng giả dưới dạng “AI analysis complete” khi chưa có inference thực.
- Không xóa hoặc ghi đè dữ liệu người dùng trong migration mà không có kế hoạch bảo toàn.

## 6. Quy trình phát triển

- Làm theo roadmap, ưu tiên MVP chạy được từ đầu đến cuối.
- Mỗi tính năng cần: trạng thái loading, empty, error, success và accessibility labels.
- Mỗi PR/commit nên nhỏ, có mô tả, test và ảnh màn hình nếu thay đổi UI.
- Khi hoàn tất một giai đoạn, cập nhật roadmap và ghi rõ phần nào thật, phần nào mock, phần nào còn phụ thuộc backend/model.
- Nếu yêu cầu mơ hồ ảnh hưởng kiến trúc, hỏi một câu làm rõ; nếu không, chọn phương án đơn giản, ghi lại giả định.
- Không thực hiện thao tác phá hủy hoặc thay đổi dịch vụ trả phí mà không có phê duyệt.

## 7. Definition of Done

Một tính năng chỉ được xem là hoàn tất khi:
- Build thành công trên simulator phù hợp.
- Luồng chính hoạt động, có xử lý lỗi và trạng thái rỗng.
- Chuỗi UI có bản dịch vi-VN, en và ko-KR nếu nằm trong phạm vi hỗ trợ.
- Có test phù hợp.
- Không có secrets trong repository.
- Tài liệu liên quan được cập nhật.
