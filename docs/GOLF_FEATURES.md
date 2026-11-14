# Golf Features Specification

## 1. Hồ sơ golfer

- Tay thuận: phải / trái.
- Trình độ: mới bắt đầu, cơ bản, trung cấp, nâng cao.
- Gậy: driver, wood, hybrid, iron (3–9), wedge, putter.
- Mục tiêu: tiếp xúc bóng, hướng bóng, khoảng cách, nhịp, ổn định, kỹ thuật cụ thể.
- Lịch sử chấn thương không phải trường bắt buộc và không nên thu thập ở MVP.

## 2. Ghi hình swing

- Dùng AVFoundation.
- Xin quyền camera đúng thời điểm và giải thích mục đích.
- Chọn camera sau/trước nếu phù hợp.
- Kiểm tra cấu hình FPS được thiết bị hỗ trợ.
- Hỗ trợ timer và đếm số cú ở mức UI.
- Lưu video vào vùng lưu trữ riêng của ứng dụng hoặc Photos chỉ khi người dùng chọn.
- Tạm dừng/tiếp tục nếu pipeline hỗ trợ ổn định; nếu không, chỉ hỗ trợ start/stop.
- Xử lý gián đoạn camera, cuộc gọi, app vào background, thiếu dung lượng và nhiệt độ thiết bị.
- Giữ nguyên video gốc; bản cắt/đánh dấu là bản dẫn xuất.

## 3. Góc quay

- Face-on và DTL là hai góc cơ bản.
- Mỗi video cần metadata góc quay.
- Không so sánh trực tiếp video Face-on với DTL.
- Hướng dẫn bố trí máy phải xét tay thuận.
- Cảnh báo an toàn: tripod ở ngoài vùng vung gậy và lối đi.

## 4. Chế độ phiên

### Tự quay
Người dùng tự quyết định số cú, xem lại và lưu video. Không bắt buộc phân tích.

### Phiên phân tích có hướng dẫn
Người dùng chọn số cú (mặc định 3 cho beginner), lựa chọn phản hồi ngay hay cuối phiên. Cho phép kết thúc sớm.

## 5. Quản lý swing

Mỗi swing có:
- Video hoặc tham chiếu video local.
- Ngày giờ.
- Góc quay.
- Gậy.
- Tay thuận tại thời điểm ghi.
- FPS/độ phân giải.
- Ghi chú.
- Trạng thái phân tích.
- Phiên bản model phân tích.

## 6. Phân tích và phản hồi

- Có thể đánh dấu các pha: vào bóng, backswing, lên đỉnh, hạ gậy, tiếp xúc bóng, kết thúc.
- Chỉ đánh dấu pha khi thuật toán có đủ dữ liệu.
- Hiển thị skeleton/keypoints khi confidence đủ cao.
- Chỉ đưa ra lỗi có bằng chứng quan sát được.
- Ưu tiên một lỗi chính và tối đa hai gợi ý.
- Bài tập phải gắn với lỗi/điểm cần cải thiện cụ thể.
- Người dùng có thể đánh dấu “hữu ích”, “không hiểu”, “không phù hợp”.

## 7. Drill library

Mỗi bài tập cần:
- ID ổn định.
- Tên và mô tả theo từng locale.
- Trình độ phù hợp.
- Gậy/góc quay áp dụng.
- Mục tiêu kỹ thuật.
- Dụng cụ cần có.
- Hướng dẫn từng bước.
- Số lần/hiệp/thời gian.
- Cảm giác nên tìm.
- Lỗi thường gặp.
- Cách tự kiểm tra.
- Cảnh báo an toàn.
- Nguồn biên soạn/kiểm duyệt và ngày cập nhật.

Không xuất bản bài tập kỹ thuật như lời khuyên chuyên môn đã được xác nhận nếu chưa qua kiểm duyệt của người có chuyên môn golf.

## 8. Hồ sơ beginner: gậy sắt số 7

Đây là hồ sơ dùng để kiểm thử trải nghiệm, không phải giới hạn sản phẩm:
- Người thuận tay phải.
- Mới bắt đầu.
- Đang học gậy sắt số 7.
- Ưu tiên setup, tiếp xúc bóng, nhịp swing và ổn định.
- Cần lời giải thích đơn giản, không bị ngợp thuật ngữ.

## 9. Nội dung ví dụ cho lỗi ngẩng đầu sớm

Tên thân thiện: “Ngẩng đầu quá sớm”.

Giải thích mẫu:
“Ở đoạn đưa gậy xuống, đầu và phần thân trên của bạn có vẻ ngẩng lên trước khi gậy chạm bóng. Điều này có thể làm thay đổi khoảng cách giữa cơ thể và bóng, khiến điểm tiếp xúc thiếu ổn định. Video hiện tại chỉ cho thấy dấu hiệu này; cần xem thêm vài cú ở cùng góc để đánh giá chắc hơn.”

Gợi ý mẫu:
“Thử tập cú đánh nửa vòng với lực nhẹ. Đưa gậy xuống chậm, giữ tư thế cúi người tự nhiên qua lúc gậy đi qua bóng. Sau đó để đầu xoay theo cú đánh. Không ghì đầu xuống và không khóa cứng cổ.”

Không tuyên bố “đầu phải giữ yên tuyệt đối”. Chuyển động đầu tự nhiên có thể xuất hiện trong swing; mục tiêu là tránh ngẩng/dựng người quá sớm nếu đó thực sự là vấn đề.
