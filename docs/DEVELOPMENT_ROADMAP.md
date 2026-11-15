# Development Roadmap

Trọng tâm MVP: **quay/nhập video → AI phân tích tư thế & cú swing → nêu lỗi → hướng dẫn sửa** (xem [PRD](PRODUCT_REQUIREMENTS.md) mục 5.1).

Hai luồng chạy song song:
- **Luồng sản phẩm:** app, quay, thư viện, nội dung bài tập.
- **Luồng phân tích:** thử pose estimation, đo pha/nhịp, nhận diện lỗi. Đây là rủi ro lớn nhất, nên bắt đầu thử nghiệm sớm (từ Phase 1) thay vì đợi cuối.

## Phase 0 — Nền tảng
- [ ] Đọc và xác nhận tài liệu sản phẩm.
- [ ] Chọn tên sản phẩm chính thức sau nghiên cứu thương hiệu.
- [x] Xác nhận ADR-001 (Flutter + module native) — [PLATFORM_DECISION.md](PLATFORM_DECISION.md).
- [x] Chốt phiên bản tối thiểu: **iOS 15, Android API 26** (2026-11-15). Ma trận thiết bị thật: còn mở.
- [x] App Flutter, điều hướng 4 tab (tab bar Cupertino trên iOS, NavigationBar trên Android). Đã chạy trên iOS simulator; Android mới build APK, chưa chạy emulator.
- [x] Plugin `capture` (Pigeon) với `probeVideo`. [x] Plugin `pose` (Pigeon) trên iOS. [ ] `pose` Android.
- [x] Localization vi, en, ko (ARB). Bản ko là bản nháp, cần biên tập viên duyệt.
- [x] Design system tối thiểu (Material 3, màu riêng, sáng/tối).
- [ ] CI build iOS + Android và unit test Dart.

## Phase 1 — Thu video và thư viện

Trạng thái lát 1 (2026-11-15). Mọi phần đánh dấu [x] là thật, không dùng mock.

- [x] Onboarding: ngôn ngữ, tay thuận, trình độ. [ ] Mục tiêu, gậy thường tập.
- [x] Home: nút quay, buổi tập gần đây, vào Cài đặt.
- [~] Hướng dẫn Face-on / DTL: hiện bằng chữ, có cảnh báo an toàn và lưu ý cho người thuận tay trái. [ ] Sơ đồ.
- [x] Camera: xem trước và quay từng cú (Bắt đầu → Dừng, tự dừng sau 15 giây), hẹn giờ, đổi camera, không xin micro, gián đoạn thì bỏ cú đang quay. Xin 60 fps; nếu máy không hỗ trợ thì dùng mặc định. FPS thật đọc từ file. [ ] Chọn FPS theo danh sách thiết bị hỗ trợ (plugin `camera` không liệt kê được, cần thêm vào `capture`). [ ] Chưa thử trên iPhone thật.
- [x] Chế độ Phân tích / Tự quay; số cú; xem lại sau mỗi cú hoặc cuối buổi (sau mỗi cú: xem lại / giữ / quay lại).
- [x] Nhập video từ thư viện (PHPicker qua `image_picker`).
- [x] Playback 0.25x/0.5x/1x, tắt tiếng, tua, từng khung hình. **Spike iOS đạt:** 6 bước ở 60 fps = đúng 100 ms. [ ] Android chưa kiểm.
- [~] Nhật ký: nhóm theo phiên, Tất cả/Yêu thích, ghi chú, `includeInStats`, swing của tôi / người khác, xóa cú/buổi. [ ] Lọc gậy/góc/ngày, màn "Ghi chú của tôi".
- [x] Chi tiết cú: tab Toàn bộ swing; tab Tư thế và Nhịp ở trạng thái "Chưa phân tích".
- [~] Xóa toàn bộ dữ liệu. [ ] Xuất ZIP.
- [~] Kiểm tra chất lượng: thời lượng, FPS. [ ] Độ phân giải, độ sáng, rung.
- **Song song:** thu thập tập video thử nghiệm có đồng ý; chọn công cụ gán nhãn.

## Phase 2 — Nội dung hướng dẫn sửa
- [ ] Danh mục lỗi ra mắt và màn giải thích từng lỗi (IssueGuide).
- [ ] Thư viện bài tập beginner 7-iron, màn chi tiết bài tập.
- [ ] Trung tâm bài tập (đề xuất, lọc góc/gậy).
- [ ] Nhật ký luyện tập; coach mark giới thiệu.
- [ ] Tiếng Việt được biên tập và kiểm thử với người dùng.
- [ ] HLV/biên tập viên duyệt nội dung.

## Phase 3 — Prototype phân tích (cốt lõi MVP)
Trạng thái lát 2a + 2b (2026-11-15):

- [~] Pose on-device: **iOS chạy thật** với MediaPipe Pose Landmarker full (Apache 2.0, đã kiểm model card). Trên simulator, clip 12 giây xử lý trong khoảng 3 giây, nhận diện người ở 100% khung. [ ] Android. [ ] Đo nhiệt và pin trên máy thật.
- [ ] Đánh giá plugin `camera` chính thức; viết plugin native nếu không đạt FPS/ổn định.
- [ ] Kiểm tra chất lượng có pose: toàn thân, che khuất.
- [ ] Thử tự phát hiện và cắt từng cú khi quay liên tục.
- [~] Nhận diện 8 pha kèm confidence (`analysis_core`, theo quỹ đạo tay). Mới kiểm bằng mắt trên 2 clip mẫu: khớp trong khoảng 1–2 khung hình. [ ] Đánh giá trên bộ video gán nhãn. [ ] Cho phép chỉnh mốc.
- [x] Đo nhịp: đưa gậy lên, dừng ở đỉnh, hạ gậy, tỷ lệ. Không hiển thị khi confidence thấp.
- [x] Lớp phủ khung xương, nút nhảy theo pha. [ ] Đường tham chiếu.
- [x] Phân tích chạy nền theo hàng đợi, có tiến trình, hủy được; tự chạy sau mỗi cú ở chế độ Phân tích; người thuận tay trái được lật keypoints.
- [~] Prototype nhận diện lỗi nhóm A (Face-on và DTL): 4 luật hình học trong `analysis_core` (AI_ANALYSIS_SPEC §10a), ngưỡng **tạm**, confidence tối đa "vừa", kiểm tra góc quay có khớp không. Chỉ bật ở bản nội bộ (cờ `EXPERIMENTAL_ISSUES`). Trên 1 clip DTL thật của golfer giỏi: cả 3 luật DTL đều "Ổn". Chưa có clip có lỗi thật để kiểm.
- [ ] Đánh giá với nhãn HLV/golfer chuyên môn; đo false positive/negative theo lỗi và góc.
- [ ] Chỉ bật các lỗi đạt ngưỡng.

## Phase 4 — Tích hợp báo cáo và hướng dẫn
- [x] Schema kết quả nhiều lỗi, mức, confidence, giới hạn (bảng `issue_observations`, DB v3).
- [~] Luật chọn lỗi ưu tiên: mức → số cú lặp lại → thứ tự biên tập → confidence (`FocusSelector`). Hiện chỉ tính trong một cú; [ ] theo phiên.
- [x] Chi tiết cú swing 3 tab: Tư thế (lỗi ưu tiên, điểm khác, các điểm đã kiểm tra, pha) / Toàn bộ swing / Nhịp.
- [ ] Danh sách lỗi theo phiên; "diễn biến theo pha" theo mức.
- [~] Từ lỗi → IssueGuide: có màn giải thích; nội dung vi/en/ko là **bản nháp chờ HLV duyệt**. [ ] Bài tập.
- [ ] Phản hồi ngay sau từng cú / tổng kết cuối phiên.
- [x] Phản hồi người dùng (hữu ích / không hiểu / không phù hợp), lưu trên máy.
- [ ] LLM diễn giải theo locale dựa trên dữ liệu có cấu trúc (nếu dùng).
- [ ] Backend job processing chỉ khi cần.

## Phase 5 — Luyện lại, tiến bộ, phát hành
- [ ] So sánh hai cú cùng góc.
- [ ] Báo cáo theo ngày và tháng, biểu đồ nhịp, mục "Cải thiện".
- [ ] Bài tập có đếm lần, xem lại cú vừa tập.
- [ ] Shot Fix (nội dung biên soạn, HLV duyệt).
- [ ] Mục tiêu ngày/tuần do người dùng đặt (mặc định tắt).
- [ ] Privacy controls nâng cao; đồng bộ cloud tùy chọn (có đồng ý riêng).
- [ ] TestFlight và Google Play internal testing; kiểm thử vi/en/ko trên cả hai nền tảng.
- [ ] Accessibility, performance, crash testing.
- [ ] Chuẩn bị App Store và Google Play (Privacy Label, Data safety).

## Hoãn
Điểm số tổng hợp, so sánh với pro, cộng đồng, phần cứng bên thứ ba, video bài tập ngoài có bản quyền.

## Nguyên tắc ưu tiên

MVP phải tạo giá trị ngay cả khi AI chưa đạt ngưỡng: người dùng vẫn quay, xem lại, ghi chú và tập theo bài tập đáng tin cậy. Nhưng đích của MVP là phân tích thật: không để phân tích dồn về cuối. Không phát hành lỗi nào chưa qua đánh giá.
