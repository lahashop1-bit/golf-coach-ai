# UI/UX Specification

Thuật ngữ theo [VIETNAMESE_GOLF_GLOSSARY.md](VIETNAMESE_GOLF_GLOSSARY.md); enum theo [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md).

## 1. Hướng thiết kế

Một design system riêng cho cả iOS và Android, điều chỉnh theo quy ước từng nền tảng (mục 12). Rõ ràng, tối giản, tương phản tốt khi dùng ở sân tập. Không sao chép pixel, icon, màu nhận diện hoặc bố cục độc quyền của GolfFix hay ứng dụng khác. Ngôn ngữ hình ảnh thể thao hiện đại, dễ đọc ngoài trời.

Ưu tiên:
- Nút lớn, thao tác được bằng một tay.
- Ít bước trước khi quay.
- Hình minh họa do dự án tự tạo hoặc có giấy phép; không dùng hình người thật làm nhân vật HLV.
- Văn bản tiếng Việt ngắn, không tràn dòng.
- Trạng thái camera và quyền riêng tư luôn rõ ràng.

## 2. Điều hướng chính (MVP)

4 tab:
1. **Trang chủ:** lời chào, nút "Quay cú swing", lỗi ưu tiên gần nhất, bài tập đang theo, buổi tập gần đây. Vào Cài đặt từ đây.
2. **Quay:** chọn chế độ, thiết lập, camera, nhập video.
3. **Nhật ký:** phiên và cú swing, lọc, yêu thích, ghi chú, so sánh; báo cáo ngày/tháng (Phase 5).
4. **Luyện tập:** bài tập đề xuất theo lỗi, thư viện bài tập, nhật ký luyện; Shot Fix (Phase 5).

Cộng đồng không có trong MVP. Thêm tab chỉ khi có nội dung thật.

## 3. Onboarding

- Chọn ngôn ngữ (mặc định theo hệ thống, đổi được sau).
- Tay thuận, trình độ, mục tiêu, gậy thường tập.
- Giải thích ngắn quyền camera và cách xử lý video (mặc định chỉ lưu trên máy).
- Bỏ qua được câu hỏi không bắt buộc.

## 4. Luồng Quay và phân tích (cốt lõi)

### 4.1 Chọn chế độ
- **Phân tích có hướng dẫn** (nhãn ngắn: "Phân tích", gắn "Khuyên dùng").
- **Tự quay**: chỉ quay và lưu.
- Nút **Nhập video** từ thư viện ảnh.

### 4.2 Thiết lập phiên phân tích
- Số cú (mặc định 3 cho người mới).
- Nhận xét sau mỗi cú: Có / Không; nếu Có, chọn thời lượng hiển thị nhận xét.
- Nếu Không: tổng kết sau phiên.
- Nút "Sẵn sàng". Luôn cho kết thúc sớm.

### 4.3 Hướng dẫn đặt máy
- Chọn Chính diện hoặc DTL; sơ đồ chỉ rõ người chơi, bóng, đường mục tiêu, chân máy (xét tay thuận).
- Cảnh báo không đặt máy trong vùng vung gậy.
- Đặt điện thoại ổn định, thấy toàn thân và đầu gậy.

### 4.4 Màn quay
- Tóm tắt chế độ ở đầu màn (đổi nhanh được).
- Góc quay; gậy (ghi chú "gậy sắt, hybrid, hoặc tập không gậy"); tay thuận; FPS (chỉ mức thiết bị hỗ trợ); hẹn giờ.
- Swing của tôi / của người khác.
- Hướng dẫn; lật camera (nếu hỗ trợ); nút "Bắt đầu quay".
- Khi quay: khung xem lớn, trạng thái đang quay rõ, thời lượng, số cú đã ghi (vd. 2/3), nút dừng dễ chạm; ít chữ phủ lên video.
- Mỗi cú là một clip (GOLF_FEATURES mục 2.1).

### 4.5 Sau mỗi cú
- Nếu bật nhận xét ngay: kết quả nhanh (lỗi ưu tiên + một điều nên thử), tự đóng sau thời lượng đã chọn, rồi sẵn sàng cú tiếp.
- Luôn có: xem lại, giữ, quay lại, xóa.
- Nếu chất lượng không đạt: nêu lý do cụ thể và nút "Quay lại".

### 4.6 Xem lại / nhập video
- Phát, tua, chọn khung hình.
- Xác nhận góc quay, gậy, tay thuận, swing của ai.
- Ghi chú tùy chọn.
- Xác nhận riêng trước khi gửi video lên cloud (chỉ khi có tính năng cloud).

### 4.7 Trạng thái phân tích
Đang xử lý (có tiến trình, hủy được), hoàn tất, không đủ chất lượng, lỗi, cần kết nối (chỉ khi cloud). Không hiển thị phần trăm chính xác.

## 5. Màn kết quả

### 5.1 Tổng kết phiên
- Số cú, tổng thời gian.
- Lỗi ưu tiên (nhãn "Nên sửa trước"), lỗi lặp lại nhiều nhất (nhãn "Lặp lại nhiều nhất"); hai nhãn có thể cùng một lỗi.
- Danh sách lỗi ("Xem thêm"), mỗi lỗi: số cú có lỗi, nút (?), mở giải thích.
- Nhịp trung bình: đưa gậy lên / dừng ở đỉnh / hạ gậy.
- Bài tập tiếp theo; ghi chú phiên.
- Danh sách cú: ảnh bìa, số thứ tự, gậy · góc · tay thuận, lỗi chính (+N), nhãn mức, yêu thích, nút chi tiết.

### 5.2 Chi tiết một cú (3 tab)
Tư thế · Toàn bộ swing · Nhịp — nội dung ở [GOLF_FEATURES.md](GOLF_FEATURES.md) mục 8.
- Toàn bộ swing: tua, tốc độ 0.25x/0.5x/1x, từng khung hình, tắt tiếng, 8 nút pha, bật/tắt khung xương và đường tham chiếu, khung hình minh họa có đánh dấu.
- Tư thế: diễn biến theo pha, chọn lỗi theo pha, nút "Xem cách sửa".
- Tab chưa có dữ liệu (trước Phase 3–4 hoặc chế độ Tự quay chưa phân tích): trạng thái rỗng có nút "Phân tích cú này".

### 5.3 Giải thích lỗi (IssueGuide)
Điều AI quan sát thấy · Vì sao có thể quan trọng · Một điều nên thử · Cảm giác cần tìm · Cách tự kiểm tra · Lỗi thường gặp · Góc quay nên dùng · Bài tập đề xuất · Phản hồi "hữu ích / không hiểu / không phù hợp".

### 5.4 Mức và mức tin cậy
- Nhãn mức theo AI_ANALYSIS_SPEC mục 5: Ổn / Nên chú ý / Cần xem lại / Chưa đủ dữ liệu. Có biểu tượng và chữ.
- Nhận xét hiển thị kèm mức tin cậy bằng lời ("có vẻ", "khá rõ"), không dùng con số. Nhận xét tin cậy thấp không hiển thị.
- Không hiển thị điểm số x/10, x/100.
- Mỗi kết quả có dòng giới hạn ("Video 2D chưa phản ánh đủ chuyển động 3D").

## 6. Luyện tập

- Trung tâm bài tập: tab Đề xuất (theo lỗi gần đây) / Chính diện / DTL; lọc theo gậy; hiển thị độ khó sửa của lỗi liên quan; gợi ý góc quay phù hợp.
- Giới thiệu "Bài tập tư thế là gì" lần đầu, bỏ qua được.
- Chi tiết bài tập: tên dễ hiểu, mục tiêu, chuẩn bị, từng bước, số lần/hiệp/thời gian, cảm giác đúng, lỗi thường gặp, cách tự kiểm tra, điều kiện dừng nếu đau.
- Phase 5: chế độ tập có đếm lần và quay kiểm tra; Shot Fix (lưới lỗi bóng, hình minh họa tự thiết kế, có nhãn chữ).

## 7. Nhật ký và báo cáo

- Tab Tất cả / Yêu thích; nhóm theo phiên; lọc gậy, góc, ngày, lỗi.
- Ghi chú: gắn với cú/phiên; có màn "Ghi chú của tôi" tổng hợp (Phase 1).
- Chọn nhiều để so sánh hai cú **cùng góc**, phát song song.
- Phase 5: báo cáo ngày/tháng (chọn ngày, lỗi lặp lại nhiều nhất, so với kỳ trước, biểu đồ nhịp từng cú, mục "Cải thiện" khi đủ dữ liệu). Không kết luận tiến bộ từ một video.
- Biểu đồ có mô tả văn bản cho trình đọc màn hình (VoiceOver, TalkBack).

## 8. Cài đặt

Ngôn ngữ; tay thuận và hồ sơ; đơn vị đo; quyền riêng tư, quản lý dung lượng video, xuất dữ liệu, xóa dữ liệu; gói đăng ký nếu có; trợ giúp và phản hồi.

## 9. Định nghĩa góc quay

### Chính diện (Face-on)
Camera đặt phía trước người chơi, nhìn ngang qua cơ thể, vuông góc tương đối với đường mục tiêu. Khung hình thấy đầu, thân, chân, tay và toàn bộ gậy.

### Dọc đường mục tiêu (DTL)
Camera đặt phía sau người chơi, nhìn dọc theo đường mục tiêu. Hướng dẫn căn máy để không quá gần/quá xa đường tay; vị trí minh họa theo tay thuận và bố trí sân tập.

Không dùng hướng dẫn "camera phía sau" mơ hồ. Dùng sơ đồ chỉ rõ người chơi, bóng, đường mục tiêu và chân máy.

## 10. Khả năng tiếp cận

- Cỡ chữ hệ thống (Dynamic Type trên iOS, font scale trên Android).
- VoiceOver và TalkBack; mọi nút có nhãn.
- Màu không phải tín hiệu duy nhất.
- Hỗ trợ giảm chuyển động.
- Phụ đề cho video hướng dẫn.
- Bản dịch không bị cắt ở tiếng Việt và tiếng Hàn.

## 11. Trạng thái bắt buộc cho mọi màn

Loading, rỗng (có hướng dẫn hành động đầu tiên), lỗi, thành công, nhãn trợ năng. Ví dụ rỗng ở Nhật ký: "Bạn chưa có cú swing nào. Hãy quay cú đầu tiên."

## 12. Khác biệt theo nền tảng

| Hành vi | iOS | Android |
|---|---|---|
| Quay lại | Vuốt từ cạnh trái, nút back trên thanh | Nút/cử chỉ Back hệ thống; hỏi xác nhận nếu đang quay |
| Xin quyền | Hộp thoại hệ thống, chuỗi trong InfoPlist | Hộp thoại runtime; hướng dẫn mở Cài đặt khi bị từ chối vĩnh viễn |
| Chọn video | PHPicker | Photo Picker hệ thống |
| Chia sẻ | Share sheet iOS | Share intent Android |
| Thanh điều hướng | Tab bar dưới | Navigation bar dưới (Material 3) |
| Trợ năng | VoiceOver | TalkBack |

Bố cục, nội dung và luồng giống nhau trên hai nền tảng; chỉ khác ở các điểm trên.

## 13. Ảnh tham chiếu

Ảnh chụp ứng dụng khác do người dùng cung cấp chỉ dùng để rút ra nhu cầu và luồng (xem [REFERENCE_FEATURE_ANALYSIS.md](REFERENCE_FEATURE_ANALYSIS.md)). Không lưu ảnh vào repo; mọi giao diện, hình minh họa và chữ do dự án tự tạo.
