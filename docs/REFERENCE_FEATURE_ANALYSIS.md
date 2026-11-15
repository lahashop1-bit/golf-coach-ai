# Reference Feature Analysis — Phân tích tính năng từ ảnh tham chiếu

Tài liệu sống. Mỗi lô ảnh mới được thêm vào một mục "Lô N" bên dưới và đối chiếu với các tài liệu khác.

## Quyết định đã chốt (hiện hành)

Chủ dự án xác định: **MVP cần nhất là dùng camera để phân tích tư thế và cú swing, sau đó nêu lỗi và hướng dẫn khắc phục.** Các quyết định mặc định bên dưới do Claude đề xuất; chủ dự án có thể đổi.

| # | Quyết định | Nguồn |
|---|---|---|
| D1 | Vòng cốt lõi MVP: quay/nhập → phân tích → lỗi → hướng dẫn sửa → luyện lại | Chủ dự án |
| D2 | Điều hướng MVP 4 tab: Trang chủ, Quay, Nhật ký, Luyện tập | Mặc định đề xuất |
| D3 | Không điểm số x/10, x/100; dùng nhãn mức | Mặc định đề xuất (theo CLAUDE.md mục 5) |
| D4 | Không so sánh với pro, không vùng nhịp "chuẩn" kiểu pro | Mặc định đề xuất |
| D5 | Shot Fix là Should have | Mặc định đề xuất |
| D6 | Mục tiêu ngày/tuần là Should have, mặc định tắt | Mặc định đề xuất |
| D7 | Cộng đồng, thiết bị phụ ngoài MVP | Mặc định đề xuất |
| D8 | Phân tích chạy trên máy; lỗi chỉ bật khi qua đánh giá | Theo AI spec |
| D9 | Chạy trên iOS và Android: Flutter + module native camera/pose ([PLATFORM_DECISION.md](PLATFORM_DECISION.md)) | Chủ dự án yêu cầu đa nền tảng; framework do Claude đề xuất |

Bổ sung khi rà soát cuối (2026-11-15):
- Mỗi cú swing là một clip; quay bằng nút hoặc hẹn giờ ở Phase 1, tự cắt cú ở Phase 3.
- Không tài khoản ở MVP; nội dung hướng dẫn đóng gói trong app.
- Độ khó sửa thuộc về lỗi (IssueGuide), không thuộc bài tập.
- Lỗi chưa đạt ngưỡng chỉ chạy trong bản nội bộ.

> **Lưu ý đọc tài liệu này:** các bảng ở Lô 1 và Lô 2 là ghi chép tại thời điểm phân tích ảnh. Cột "Trạng thái" và "Phase" ở đó đã cũ; **nguồn chính là PRD (phạm vi) và Roadmap (phase)**. Các câu hỏi mở ở hai lô đã được giải quyết bằng D1–D9.

Các tài liệu đã cập nhật theo quyết định này: PRD (mục 5), UI/UX (mục 6–12), Golf Features (mục 10–16), AI Analysis (mục 9–14), Acceptance (mục 9–14), Architecture (mục 9–11), Database (mục 9), I18N (mục 8), Roadmap, Glossary.

---

## Nguyên tắc sử dụng

- Đây là danh sách **nhu cầu và hành vi** quan sát được từ ảnh chụp một ứng dụng golf khác (người dùng cung cấp). Không phải yêu cầu sao chép giao diện, màu sắc, bố cục, câu chữ, icon, video hay nội dung huấn luyện.
- Mọi màn hình, minh họa, tên bài tập, văn bản tiếng Việt phải do dự án tự thiết kế hoặc có giấy phép (xem [CLAUDE.md](../CLAUDE.md) mục 5).
- Các điểm số, tỷ lệ phần trăm, "pts" trong ảnh là dữ liệu của app khác. Dự án **không được hiển thị điểm số nếu chưa có thuật toán đã hiệu chuẩn** (xem [AI_ANALYSIS_SPEC.md](AI_ANALYSIS_SPEC.md) mục 4).
- Chưa lưu ảnh gốc vào repo (có thể chứa dữ liệu cá nhân, video người thật, nội dung có bản quyền).

---

## Lô 1 — 16 ảnh (báo cáo phân tích, nhịp swing, bài tập tư thế)

### 1. Kiểm kê màn hình

| # | Màn hình quan sát | Thành phần chính |
|---|---|---|
| 1 | Danh sách "Lỗi phát hiện" (modal) | Nhãn "thường gặp nhất", "trọng tâm của HLV"; mỗi lỗi có số cú bị lỗi, nút giải thích (?), mở rộng |
| 2 | Danh sách báo cáo từng cú | Bộ lọc (loại, lỗi, điểm); chế độ chọn nhiều; nút so sánh; thẻ cú swing: ảnh bìa, số thứ tự, gậy · góc quay · tay thuận, lỗi chính + N lỗi khác, điểm tư thế /10, nhịp, yêu thích, thêm, chi tiết |
| 3 | Báo cáo theo ngày | Chọn ngày (lịch); lỗi phổ biến nhất; thanh tỷ lệ mức độ nặng/nhẹ; mục "Cải thiện"; lọc Tất cả/Iron/Driver; nút đặt lại và lên đầu trang |
| 4 | Nhịp · Tempo theo ngày | Nhịp trung bình, thời gian swing trung bình, so với ngày trước; biểu đồ cột (đưa lên/hạ xuống) + đường nhịp theo từng cú; so sánh cú nhanh nhất và chậm nhất |
| 5, 11 | Thẻ lỗi có biểu đồ xu hướng | Điểm theo số cú, vùng "đạt", đường trung bình, "+N lỗi khác", nút xem báo cáo từng cú |
| 6 | Tab Tư thế (chi tiết 1 cú) | Bài tập trọng tâm, độ khó sửa, tần suất 5 ngày gần nhất, nút vào bài tập; "Diễn biến theo bước" (8 bước, mỗi bước Đạt/Chưa đạt/Gần đạt); video luyện tập gợi ý; thanh dưới: ghi chú, chia sẻ, yêu thích, thêm |
| 7 | Lỗi theo bước (modal) | Chọn một lỗi của pha (vd. khởi động đưa gậy), nhãn mức độ, thang điểm /100 |
| 8 | Tab Nhịp · Tempo (chi tiết 1 cú) | Chú giải biểu đồ (cú của tôi / nhịp của tôi / vùng nhịp tốt / cú của pro); "Tổng quan"; "Thử điều này"; nút bắt đầu bài tập nhịp |
| 9 | Tab Toàn bộ swing | Thanh tua video, tốc độ 0.5x, tắt tiếng, 8 nút nhảy tới pha swing; "Thông tin cú swing" (góc quay, gậy, thời điểm phân tích, tay thuận, đồng bộ video, có tính vào thống kê tích lũy không); nút Hướng dẫn, Ảnh trong ngày |
| 10 | Video có lớp phủ | Khung xương, đường dọc tham chiếu, vòng đánh dấu đầu; bật/tắt lớp phủ; Tôi/Pro; so sánh |
| 12 | Trung tâm bài tập tư thế | Tab Đề xuất/Face-on/DTL; lọc gậy; xếp hạng lỗi theo số lần và %; độ khó sửa; gợi ý "tập ở góc DTL chính xác hơn"; video bài tập; lịch sử |
| 13–16 | Giới thiệu tính năng bài tập (4 màn) | Bài tập tư thế là gì → chọn lỗi, xem giải pháp → từ phân tích đến báo cáo → luyện lặp lại |

### 2. Đối chiếu với tài liệu hiện có

Ký hiệu: ✅ đã có trong spec · 🟡 có một phần · ❌ chưa có.

| # | Tính năng | Trạng thái | Đề xuất cho Golf Coach AI | Phase |
|---|---|---|---|---|
| F1 | Danh sách lỗi của một phiên/ngày, xếp theo tần suất | 🟡 (AI spec chỉ có `priority_focus_id`) | Mở rộng schema: nhiều `observations`, đếm số cú bị lỗi trong phiên | 4 |
| F2 | Nhãn "Thường gặp nhất" và "Trọng tâm" tách biệt | ❌ | Giữ hai khái niệm: *tần suất* (đếm được) và *ưu tiên sửa* (biên soạn/duyệt). Chỉ nêu 1–2 lỗi (PRD mục 4) | 4 |
| F3 | Giải thích (?) cho từng lỗi | 🟡 | Mỗi lỗi có màn giải thích: quan sát gì, vì sao có thể quan trọng, cách tự kiểm tra | 2 |
| F4 | Danh sách từng cú: ảnh bìa, gậy · góc · tay thuận, lỗi chính, yêu thích, chi tiết | 🟡 (History) | Thêm `isFavorite`; thẻ cú swing hiển thị lỗi chính + "N lỗi khác" | 1 |
| F5 | Lọc theo loại / lỗi / điểm, chọn nhiều, so sánh | 🟡 | Lọc theo gậy, góc, lỗi, ngày. Chọn 2 cú **cùng góc** để so sánh (giữ quy tắc không so Face-on với DTL) | 5 |
| F6 | Báo cáo theo ngày + chọn ngày bằng lịch | ❌ | Màn "Báo cáo ngày": lỗi lặp lại nhiều nhất, so với ngày trước, lọc theo gậy | 5 |
| F7 | Thanh tỷ lệ mức nặng/nhẹ cho mỗi lỗi | ❌ | Dùng 3 mức chữ + biểu tượng (không chỉ màu — UI_UX_SPEC mục 10). Cần định nghĩa ngưỡng được kiểm chứng | 4 |
| F8 | Mục "Cải thiện" (lỗi giảm theo thời gian) | ❌ | Chỉ hiển thị khi có đủ số cú ở cùng góc/gậy; không kết luận từ 1 video (UI_UX_SPEC mục 7) | 5 |
| F9 | Nhịp swing (tỷ lệ đưa lên : hạ xuống) và thời gian swing | 🟡 (chỉ có từ "Tempo") | Đo được từ mốc thời gian các pha → tính khả thi cao nhất, nên làm sớm trong Phase 3 | 3 |
| F10 | Biểu đồ nhịp theo từng cú; cú nhanh nhất/chậm nhất | ❌ | Biểu đồ cột + đường; có mô tả văn bản cho VoiceOver | 5 |
| F11 | Vùng nhịp "tốt" và so với pro | ❌ | **Hoãn**: cần nguồn tham chiếu có giấy phép. Có thể chỉ dùng khoảng tham khảo được biên tập viên duyệt, ghi rõ chỉ là tham khảo | 5+ |
| F12 | Điểm tư thế /10, /100, "pts" | ❌ | **Không làm ở MVP.** Chỉ bật khi có thuật toán hiệu chuẩn và giải thích ý nghĩa. Thay bằng mức: Ổn / Nên chú ý / Cần xem lại | 4+ |
| F13 | Tab trong chi tiết cú: Tư thế / Toàn bộ swing / Nhịp | ❌ | Chi tiết cú swing 3 tab tương ứng | 1–4 |
| F14 | Tua video, chậm 0.5x, tắt tiếng | 🟡 (playback) | Tốc độ 0.25x/0.5x/1x, tua từng khung hình | 1 |
| F15 | 8 nút nhảy tới pha swing | 🟡 | Pha: vào bóng, khởi động đưa gậy, đưa gậy lên, đỉnh, hạ gậy, tiếp xúc, kết thúc đà, kết thúc. Chỉ hiện khi tìm được pha; cho người dùng tự chỉnh mốc | 3 |
| F16 | Khung xương, đường dọc, vòng đầu | 🟡 | Hiện khi confidence đủ; nút bật/tắt; có chú thích | 3 |
| F17 | So sánh "Tôi / Pro" | ❌ | **Hoãn.** Thay bằng so sánh "Tôi hôm nay / Tôi trước đó" | 5 |
| F18 | "Diễn biến theo bước" (8 bước Đạt/Chưa đạt/Gần đạt) | ❌ | Tóm tắt 8 pha bằng biểu tượng + chữ. Chỉ gắn nhãn cho pha có đủ bằng chứng; pha thiếu dữ liệu ghi "Chưa đủ dữ liệu" | 4 |
| F19 | Chọn lỗi theo pha (modal) | ❌ | Danh sách lỗi theo pha, chọn để xem khung hình và bài tập | 4 |
| F20 | Thông tin cú swing (metadata, có tính vào thống kê hay không) | 🟡 | Thêm công tắc "Tính vào thống kê" để loại cú thử/quay hỏng | 1 |
| F21 | Bài tập trọng tâm + độ khó sửa + tần suất 5 ngày | 🟡 | Độ khó do biên tập viên gán cho từng lỗi (IssueGuide), không do AI. Tần suất tính từ dữ liệu thật của người dùng | 2–4 |
| F22 | Trung tâm bài tập: đề xuất, lọc góc/gậy, xếp hạng | 🟡 (drill library) | Tab Đề xuất / theo góc. Gợi ý góc quay phù hợp hơn cho từng lỗi (thuộc tính drill) | 2 |
| F23 | Bài tập lặp lại có đếm | 🟡 (`UserDrillLog`) | Chế độ tập có hướng dẫn: đếm lần, xem lại cú vừa tập, ghi nhận hoàn thành | 4–5 |
| F24 | Video luyện tập gợi ý từ nguồn ngoài | ❌ | Chỉ dùng video do dự án làm hoặc có giấy phép/ nhúng hợp lệ; hiển thị nguồn | 5+ |
| F25 | Thanh dưới: ghi chú, chia sẻ, yêu thích, thêm | 🟡 | Ghi chú + yêu thích ở MVP; chia sẻ cần xác nhận quyền riêng tư (xóa metadata, hỏi trước khi gửi) | 1 / 5 |
| F26 | Màn giới thiệu tính năng (4 màn) | ❌ | Giới thiệu lần đầu, bỏ qua được, thiết kế riêng | 2 |
| F27 | Nút nhảy lên đầu trang, đặt lại bộ lọc | ❌ | Chi tiết UI nhỏ, làm khi cần | – |
| F28 | Phân tích tự động hóa theo thời điểm ("Analysis time") | 🟡 | Dùng `completedAt`, `modelVersion` của SwingAnalysis | 4 |

### 3. Tính khả thi trung thực

Dựa trên [AI_ANALYSIS_SPEC.md](AI_ANALYSIS_SPEC.md). Chưa kiểm chứng bằng thực nghiệm; cần Phase 3 xác nhận.

| Nhóm | Khả năng đo từ video 2D | Ghi chú |
|---|---|---|
| Nhịp / thời gian swing | Cao (nếu tìm đúng mốc pha) | Dựa vào thời gian, không cần góc 3D |
| Mốc pha swing | Trung bình | Phụ thuộc FPS, rung máy, che khuất |
| Ngẩng đầu, mất góc cúi lưng, đứng thẳng quá sớm | Trung bình (tốt hơn ở góc DTL cho cúi lưng) | Dùng ngôn ngữ "có vẻ", ghi rõ góc quay |
| Gập cổ tay, tay trái co | Thấp–trung bình | Cổ tay nhỏ, dễ bị che khuất; cần dữ liệu thử nghiệm |
| Xoay hông, nghiêng thân, vai nâng | Thấp–trung bình | Xoay 3D khó suy ra từ một góc 2D |
| Hất đầu gậy / xúc bóng ("scooping") | Thấp | Cần quan sát gậy và cổ tay lúc tiếp xúc |
| Đường gậy lúc khởi động (inside/outside) | Thấp–trung bình | Cần DTL và thấy gậy rõ |
| Điểm số /10, /100, so sánh với pro | Không nên làm ở MVP | Không có hiệu chuẩn, không có nguồn tham chiếu hợp lệ |

### 4. Đề xuất bổ sung theo roadmap

**Phase 1 (không cần AI):** yêu thích, ghi chú, công tắc "tính vào thống kê", lọc danh sách (gậy/góc/ngày), chi tiết cú swing có tab, playback 0.25x–1x, tua từng khung hình, hiển thị metadata cú swing.

**Phase 2 (nội dung):** màn giải thích từng lỗi (F3), thuộc tính drill: độ khó sửa, góc quay phù hợp, mức ưu tiên; trung tâm bài tập; giới thiệu tính năng.

**Phase 3 (prototype):** mốc pha, nhịp/thời gian swing (ưu tiên đầu tiên), khung xương.

**Phase 4:** danh sách lỗi nhiều mục, tần suất, trọng tâm, diễn biến theo bước, bài tập có đếm.

**Phase 5:** báo cáo ngày, biểu đồ nhịp, mục "Cải thiện", so sánh cùng góc.

**Hoãn / không làm khi chưa đủ điều kiện:** điểm số, so sánh với pro, vùng nhịp "chuẩn", video ngoài có bản quyền.

### 5. Câu hỏi mở (đã giải quyết — xem D2–D8)

1. Có muốn hiển thị **điểm số** cho người dùng không? Nếu có, cần chiến lược hiệu chuẩn (HLV gán nhãn) trước khi bật.
2. Có nguồn **swing mẫu của pro** có giấy phép không? Nếu không, bỏ F11 và F17.
3. Số lỗi tối đa phân tích mỗi cú (ảnh tham chiếu có hơn 10 lỗi) — đề xuất giới hạn hiển thị chính 1–2 lỗi, còn lại gom vào "Xem thêm".
4. Có đi cùng backend (tổng hợp theo ngày) hay tính hoàn toàn trên thiết bị? Đề xuất tính trên thiết bị ở MVP.

---

## Lô 2 — 15 ảnh (điều hướng, quay, báo cáo phiên/ngày, sửa lỗi bóng, cộng đồng)

### 1. Kiểm kê màn hình

| # | Màn hình | Thành phần chính |
|---|---|---|
| 1 | Điều hướng chính | 5 tab: Trang chủ, Học viện, Nhật ký swing, AI Coach (báo cáo), Cộng đồng; nút nổi lối tắt |
| 2 | Trang chủ | Banner thông báo cập nhật; "Việc hôm nay" với mục tiêu số lượng (phân tích, bài tập tư thế, nhịp); mục tiêu tuần có huy hiệu; lối tắt báo cáo ngày, cộng đồng; đăng nhập thiết bị phụ (phần cứng) |
| 3 | Học viện | Thẻ HLV chính (ảnh người thật); Quay swing (Bắt đầu / Nhập video); "Nhiệm vụ hôm nay"; Bài học "Sửa cú đánh"; Bài tập trọng tâm: tư thế, nhịp |
| 4 | Chọn lỗi cú đánh (Shot Fix) | Lưới 10 lỗi đường bóng/tiếp xúc: hook, slice, pull, push, mất cự ly, skying (chỉ driver), đánh dày (fat), đánh đỉnh bóng (topping), shank, bóng chạm mũi gậy (toe) |
| 5 | Chọn chế độ quay | Phân tích swing (khuyên dùng) / Tự quay (tự ghi, không phân tích); nút Nhập video |
| 6 | Thiết lập chế độ phân tích | Số cú (thanh trượt), phản hồi ngay sau mỗi cú Có/Không, thời lượng phản hồi, "Sẵn sàng" |
| 7 | Màn hình quay | Tóm tắt chế độ ở đầu; góc quay; gậy kèm ghi chú "sắt, hybrid, không cầm gậy"; tay thuận, FPS, hẹn giờ; Swing của tôi / người khác; Hướng dẫn; Lật camera |
| 8 | Tổng kết một phiên | Điểm tư thế TB, số cú, tổng thời gian swing, điểm thấp/cao nhất; nhịp TB, thời gian đưa lên, dừng ở đỉnh, hạ gậy; điểm đều nhịp; danh sách lỗi |
| 9, 10, 12, 16 | Thẻ lỗi có xu hướng, danh sách cú | Giống Lô 1 (F1–F5) |
| 11 | Tab Báo cáo (AI Coach) | Báo cáo Ngày / Tháng; chọn ngày bằng mũi tên + lịch; tổng số lần phân tích, điểm TB, nhịp TB, thời gian swing TB; "Ghi chú của tôi" |
| 13 | Nhật ký swing | Tab Quay / Bài tập / Bài học / thiết bị phụ; Tất cả (đếm) / Yêu thích; chỉ báo đồng bộ cloud + dung lượng; **cú được nhóm theo phiên**, mỗi cú có điểm trên ảnh bìa; gợi ý tính năng so sánh với pro |
| 14 | Cộng đồng | Tab Tất cả / Nổi bật / Hoạt động của tôi; bài đăng có nhãn chủ đề; dịch tự động + xem bản gốc; phản ứng, bình luận, viết bài |

### 2. Đối chiếu

| # | Tính năng | Trạng thái | Đề xuất cho Golf Coach AI | Phase |
|---|---|---|---|---|
| G1 | Điều hướng 5 tab | 🟡 (UI spec liệt kê màn hình, chưa chốt tab) | Đề xuất MVP **4 tab**: Trang chủ, Quay, Nhật ký, Luyện tập (bài tập + báo cáo trong Nhật ký/Tiến bộ). Thêm tab khi có nội dung thật | 1 |
| G2 | Chọn chế độ: Phân tích / Tự quay | ✅ (UI spec 3.x) | Giữ. Làm rõ "Tự quay" không cần AI → giá trị ngay cả khi AI chưa sẵn sàng | 1 |
| G3 | Nhập video từ Photos | ✅ (Should have) | Nâng lên Phase 1; người dùng chọn góc quay, gậy, tay thuận thủ công | 1 |
| G4 | Thiết lập: số cú, phản hồi ngay, thời lượng phản hồi | ✅ | Đã có; thêm mặc định 3 cú, tắt được | 1/4 |
| G5 | Màn quay có bảng chọn nhanh ngay trên camera | ✅ | Giữ ít bước. Ghi chú "gậy sắt, hybrid, tay không" giúp người mới hiểu: nên có | 1 |
| G6 | Swing của tôi / của người khác | ✅ | Giữ; swing người khác **không** tính vào thống kê của tôi (liên quan `includeInStats`) | 1 |
| G7 | Tự động bắt đầu/dừng quay theo chuyển động | ❌ | Rủi ro kỹ thuật; thử ở Phase 3. MVP dùng nút + hẹn giờ | 3 |
| G8 | Tổng kết phiên: số cú, tổng thời gian, thấp/cao nhất | 🟡 (UI 3.8) | Số cú, thời gian, lỗi lặp lại. Không dùng "điểm thấp/cao" cho đến khi có điểm hiệu chuẩn | 4 |
| G9 | Chi tiết nhịp: đưa lên / dừng ở đỉnh / hạ gậy (giây) | ❌ | **Ưu tiên cao**: đo được từ mốc thời gian. Có chú thích "ước tính từ video" | 3 |
| G10 | "Điểm đều nhịp" | ❌ | Thay bằng độ lệch nhịp giữa các cú (số liệu thật, giải thích rõ), không đặt điểm | 5 |
| G11 | Báo cáo Ngày + Tháng, tổng số lần phân tích | ❌ | Ngày (F6) và Tháng sau; hiển thị số liệu đếm được, không ép áp lực thành tích | 5 |
| G12 | Ghi chú của tôi (tab riêng) | 🟡 | Ghi chú gắn với cú swing/phiên + màn tổng hợp ghi chú | 1 |
| G13 | Nhóm các cú theo phiên trong Nhật ký | ✅ (`SwingSession`) | Thẻ phiên: ngày, gậy, góc, số cú, lỗi chính | 1 |
| G14 | Yêu thích / tab Yêu thích | ✅ (F4) | Giữ | 1 |
| G15 | Đồng bộ cloud + hiển thị dung lượng | 🟡 | Mặc định **chỉ lưu trên máy**. Cloud là tùy chọn, có đồng ý riêng (CLAUDE.md mục 5); hiển thị dung lượng đã dùng | 5 |
| G16 | Nhiệm vụ hôm nay, mục tiêu số lượng, mục tiêu tuần, huy hiệu | 🟡 (PRD "mục tiêu tuần") | Mục tiêu **do người dùng đặt**, nhẹ nhàng, không phạt khi bỏ lỡ; huy hiệu tối thiểu. Tránh khuyến khích tập quá sức (PRD mục 6) | 5 |
| G17 | Chọn lỗi cú đánh (hook, slice, pull, push, mất cự ly, fat, topping, shank, toe, skying) | ❌ | Tính năng **nội dung có hướng dẫn**: người dùng tự chọn lỗi bóng → câu hỏi ngắn → nguyên nhân thường gặp → bài tập đã duyệt. **Không suy ra đường bóng từ video**; nếu muốn nhập, để người dùng tự mô tả. Một số lỗi chỉ áp dụng driver | 2 |
| G18 | Thẻ HLV chính bằng ảnh người thật | ❌ | **Không dùng** ảnh/hình người thật hay tên nhận diện. Nếu cần nhân vật, tự thiết kế, ghi rõ là AI | 2 |
| G19 | Cộng đồng (bài đăng, nhãn, bình luận, dịch AI, phản ứng) | ❌ | **Ngoài MVP** (PRD: Không mạng xã hội). Nếu làm sau cần: kiểm duyệt, báo cáo vi phạm, chặn người dùng, quyền riêng tư video, nhãn "dịch bằng AI" | Hoãn |
| G20 | Banner cập nhật / thông báo | ❌ | Không cần MVP; nếu có, không dùng khẳng định "chính xác hơn" thiếu số liệu | – |
| G21 | Đăng nhập thiết bị phụ/phần cứng | ❌ | Ngoài phạm vi (PRD Not in MVP) | Hoãn |
| G22 | Tooltip giới thiệu tính năng mới | ❌ | Coach mark nhẹ, bỏ qua được | 2 |
| G23 | Mục tiêu lỗi hiển thị trên thẻ cú swing kèm điểm ảnh bìa | 🟡 | Ảnh bìa kèm nhãn mức (Ổn / Chú ý / Xem lại), không chỉ màu | 4 |

### 3. Ghi chú sản phẩm

- **Điểm số và nhãn "Pass/Đạt"**: Lô 2 lặp lại điểm số (/10, "pts", trung bình). Giữ quyết định ở Lô 1 (F12): chưa hiển thị điểm cho đến khi có hiệu chuẩn. Số liệu đo trực tiếp (số cú, thời gian pha, nhịp) được phép hiển thị sớm.
- **Lỗi bóng ≠ lỗi tư thế**: Shot Fix (G17) đi từ *kết quả* (bóng cong, đánh dày) tới *nguyên nhân có thể*. Đây là nội dung biên soạn, tốt cho MVP vì không cần AI. Cần HLV rà soát; dùng ngôn ngữ xác suất ("thường do", "có thể").
- **Cú swing không cầm gậy**: màn quay nêu rõ có thể tập không gậy. Cần xét `clubType = none` trong schema.
- **Thống kê tích lũy**: có công tắc loại cú khỏi thống kê (F20) → cần cho cả cú của người khác (G6).
- **Quyền riêng tư**: cloud, cộng đồng, chia sẻ cần đồng ý riêng; không tải video khi chưa thông báo.

### 4. Cập nhật đề xuất roadmap (Lô 2)

- **Phase 1:** nhập video từ Photos, ghi chú, nhóm theo phiên, `includeInStats`, 4 tab điều hướng, hướng dẫn "tập không gậy".
- **Phase 2:** Shot Fix (G17), coach mark, giới thiệu bài tập.
- **Phase 3:** thời gian từng pha (G9), thử tự động bắt đầu/dừng.
- **Phase 5:** báo cáo ngày/tháng, mục tiêu do người dùng đặt, đồng bộ cloud tùy chọn.
- **Hoãn:** cộng đồng, phần cứng, nhân vật HLV bằng người thật.

### 5. Câu hỏi mở bổ sung (đã giải quyết — xem D2, D5, D6)

1. Đồng ý MVP chỉ 4 tab, không có Cộng đồng?
2. Shot Fix có đưa vào MVP (nội dung biên soạn, không AI) không? Cần HLV/biên tập viên duyệt.
3. Mục tiêu hàng ngày/tuần: có làm không, và mặc định tắt hay bật?
