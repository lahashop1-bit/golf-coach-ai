# Product Requirements Document (PRD)

## 1. Tầm nhìn

Xây dựng một huấn luyện viên golf cá nhân trên iPhone và Android. Người chơi quay video cú đánh, nhận phản hồi dễ hiểu, biết một hoặc hai điểm cần sửa và có bài tập phù hợp để luyện tập. Sản phẩm ưu tiên người mới và tiếng Việt tự nhiên, đồng thời phục vụ người dùng tiếng Anh và tiếng Hàn.

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

### 5.1 Vòng giá trị cốt lõi (trọng tâm MVP)

> **Quay hoặc nhập video → AI phân tích tư thế và cú swing → nêu lỗi quan sát được → hướng dẫn cách sửa → luyện lại và so sánh.**

Mọi quyết định ưu tiên đều dựa trên vòng này. Các tính năng khác chỉ nằm trong MVP nếu phục vụ trực tiếp vòng này.

Chi tiết 7 bước của vòng:
1. **Chuẩn bị:** hướng dẫn đặt máy theo góc Face-on hoặc DTL; chọn gậy, tay thuận.
2. **Thu video:** quay bằng camera trong app hoặc nhập từ thư viện ảnh của máy; mỗi cú là một clip.
3. **Kiểm tra chất lượng:** đủ sáng, thấy toàn thân, ít rung; nếu không đạt thì nói rõ lý do và hướng dẫn quay lại.
4. **Phân tích trên máy:** ước lượng tư thế (pose), tìm các pha swing, đo nhịp, nhận diện lỗi theo luật/mô hình đã kiểm chứng.
5. **Báo cáo:** 1–2 lỗi nên sửa trước, các lỗi khác ở mục "Xem thêm"; mỗi lỗi có bằng chứng, mức tin cậy và giới hạn.
6. **Hướng dẫn sửa:** giải thích dễ hiểu, một điều nên thử, bài tập đã được biên tập duyệt, cách tự kiểm tra.
7. **Luyện lại:** quay lại cùng góc, so với lần trước của chính người dùng, theo dõi lỗi nào giảm.

### 5.2 Must have (MVP)

**A. Thu video**
- Onboarding: ngôn ngữ, tay thuận, trình độ, mục tiêu (bỏ qua được).
- Hướng dẫn quay Face-on và DTL bằng sơ đồ; cảnh báo an toàn.
- Quay bằng camera điện thoại (iPhone và Android); xem lại, quay lại, lưu, xóa.
- Nhập video từ thư viện ảnh qua trình chọn hệ thống (chọn góc quay, gậy, tay thuận thủ công).
- Chọn gậy (gồm cả tập không gậy), tay thuận, FPS và hẹn giờ theo khả năng thiết bị.
- Hai chế độ: **Phân tích có hướng dẫn** (số cú, phản hồi ngay hoặc cuối phiên) và **Tự quay** (không phân tích).

**B. Phân tích (cốt lõi)**
- Kiểm tra chất lượng video trước khi phân tích.
- Pose estimation trên máy, có điểm tin cậy.
- Nhận diện các pha swing (vào bóng, khởi động đưa gậy, đưa lên, đỉnh, hạ gậy, tiếp xúc, kết thúc đà, kết thúc), chỉ gán khi đủ bằng chứng; người dùng có thể chỉnh mốc.
- Đo nhịp: thời gian đưa lên, dừng ở đỉnh, hạ gậy và tỷ lệ nhịp.
- Nhận diện lỗi theo **bộ lỗi ra mắt** (xem [AI_ANALYSIS_SPEC.md](AI_ANALYSIS_SPEC.md) mục 10). Mỗi lỗi có mức (AI spec mục 5), mức tin cậy, góc quay áp dụng và giới hạn.
- Lớp phủ khung xương và đường tham chiếu, bật/tắt được.
- Tổng hợp theo phiên: lỗi lặp lại nhiều cú, lỗi ưu tiên.

**C. Hướng dẫn sửa (cốt lõi)**
- Màn giải thích từng lỗi: AI thấy gì, vì sao có thể quan trọng, cảm giác nên tìm, một điều nên thử.
- Thư viện bài tập beginner (gậy sắt số 7) đã được biên tập duyệt, gắn với từng lỗi.
- Chi tiết bài tập: bước thực hiện, số lần, lỗi thường gặp, cách tự kiểm tra, cảnh báo dừng khi đau.
- Phản hồi "hữu ích / không hiểu / không phù hợp" cho từng nhận xét.

**D. Lưu trữ và theo dõi**
- Nhật ký swing: nhóm theo phiên, lọc theo gậy/góc/ngày/lỗi, yêu thích, ghi chú (kèm màn "Ghi chú của tôi"), công tắc "tính vào thống kê".
- So sánh hai cú **cùng góc** của chính người dùng.
- Chi tiết một cú swing có 3 tab: Tư thế, Toàn bộ swing, Nhịp.
- Localization vi-VN, en, ko-KR.
- Quyền riêng tư: xử lý trên máy mặc định; xóa video; xuất dữ liệu cơ bản.

### 5.3 Should have (sau khi vòng cốt lõi chạy ổn)
- Sửa cú đánh (Shot Fix): người dùng chọn lỗi bóng (cong trái/phải, đánh dày, đánh đỉnh…) → nguyên nhân thường gặp → bài tập đã duyệt. Nội dung biên soạn, không suy ra đường bóng từ video.
- Báo cáo theo ngày và theo tháng; biểu đồ nhịp theo từng cú.
- Mục "Cải thiện" khi có đủ cú cùng góc/gậy.
- Mục tiêu ngày/tuần do người dùng đặt (mặc định tắt).
- Nhắc luyện tập.
- Bộ lỗi mở rộng sau khi được kiểm chứng.
- Đồng bộ cloud tùy chọn có đồng ý riêng.

### 5.4 Not in MVP
- Điểm số tổng hợp dạng x/10, x/100 (chỉ cân nhắc khi có hiệu chuẩn và giải thích).
- So sánh với swing của người chơi chuyên nghiệp (chưa có nguồn có giấy phép).
- Vùng nhịp "chuẩn" kiểu pro (chỉ dùng khoảng tham khảo đã duyệt nếu có).
- Cộng đồng, bảng xếp hạng, marketplace, dịch bài đăng.
- Đo tốc độ đầu gậy, tốc độ bóng, spin, launch angle, đường bóng từ video.
- Phân tích 3D chính xác; chẩn đoán y khoa/chấn thương.
- Thiết bị golf bên thứ ba; video bài tập ngoài có bản quyền; nhân vật HLV dùng hình người thật.

### 5.5 Điều kiện phát hành tính năng AI
Phân tích chỉ được bật cho người dùng cuối với **những lỗi đã đạt ngưỡng chất lượng** theo [ACCEPTANCE_CRITERIA.md](ACCEPTANCE_CRITERIA.md) mục 8. Lỗi chưa đạt ngưỡng chỉ chạy trong bản nội bộ (build dev, TestFlight, Google Play internal testing) với nhãn "thử nghiệm" để thu thập đánh giá; không xuất hiện trong bản phát hành công khai. Trước khi có lỗi nào đạt ngưỡng, bản công khai vẫn có giá trị nhờ quay, xem lại, đo nhịp (nếu đạt), ghi chú và bài tập.

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

Mọi giá, gói và entitlement phải được cấu hình từ backend/App Store/Google Play, không hard-code.

## 8. Rủi ro và giả định

- Video 2D có giới hạn quan sát chiều sâu và khớp bị che khuất.
- Chất lượng phân tích phụ thuộc ánh sáng, góc máy, tốc độ màn trập, quần áo và toàn thân trong khung.
- Một lỗi hình ảnh có thể có nhiều nguyên nhân; AI phải dùng ngôn ngữ xác suất.
- Cần xác minh tính khả thi và chi phí của pose estimation trên thiết bị trước khi chọn mô hình.
- Quyền sử dụng mô hình/dataset phải được kiểm tra trước khi đưa vào sản phẩm.

## 9. Tham chiếu

Phân tích tính năng từ ảnh tham chiếu: [REFERENCE_FEATURE_ANALYSIS.md](REFERENCE_FEATURE_ANALYSIS.md). Danh sách quyết định sản phẩm hiện hành nằm ở mục "Quyết định đã chốt" trong file đó.
