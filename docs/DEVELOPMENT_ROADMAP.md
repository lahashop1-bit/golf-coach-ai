# Development Roadmap

Trọng tâm MVP: **quay/nhập video → AI phân tích tư thế & cú swing → nêu lỗi → hướng dẫn sửa** (xem [PRD](PRODUCT_REQUIREMENTS.md) mục 5.1).

Hai luồng chạy song song:
- **Luồng sản phẩm:** app, quay, thư viện, nội dung bài tập.
- **Luồng phân tích:** thử pose estimation, đo pha/nhịp, nhận diện lỗi. Đây là rủi ro lớn nhất, nên bắt đầu thử nghiệm sớm (từ Phase 1) thay vì đợi cuối.

## Phase 0 — Nền tảng
- [ ] Đọc và xác nhận tài liệu sản phẩm.
- [ ] Chọn tên sản phẩm chính thức sau nghiên cứu thương hiệu.
- [x] Xác nhận ADR-001 (Flutter + module native) — [PLATFORM_DECISION.md](PLATFORM_DECISION.md).
- [ ] Chốt phiên bản iOS/Android tối thiểu và ma trận thiết bị thử nghiệm.
- [ ] Tạo app Flutter chạy được trên iOS simulator và Android emulator, điều hướng 4 tab (Trang chủ, Quay, Nhật ký, Luyện tập).
- [ ] Khung plugin native `capture` và `pose` (Pigeon) với API tối thiểu.
- [ ] Thiết lập localization vi-VN, en, ko-KR.
- [ ] Design system tối thiểu.
- [ ] CI build iOS + Android và unit test Dart.

## Phase 1 — Thu video và thư viện
- [ ] Onboarding hồ sơ golfer.
- [ ] Home.
- [ ] Hướng dẫn Face-on / DTL bằng sơ đồ.
- [ ] Camera preview và recording; chọn gậy (gồm tập không gậy), tay thuận, FPS, hẹn giờ.
- [ ] Chế độ Phân tích / Tự quay; số cú; phản hồi ngay hoặc cuối phiên.
- [ ] Nhập video từ Photos.
- [ ] Playback 0.25x–1x; thử tua từng khung hình bằng `video_player` trên cả hai nền tảng (spike), thay bằng player native nếu không đạt; lưu, xóa video.
- [ ] Nhật ký: nhóm theo phiên, lọc, yêu thích, ghi chú, màn "Ghi chú của tôi", `includeInStats`, swing của tôi / người khác.
- [ ] Chi tiết cú: tab Toàn bộ swing (chưa có lớp phủ); tab Tư thế và Nhịp ở trạng thái rỗng.
- [ ] Xuất dữ liệu (ZIP) và xóa dữ liệu.
- [ ] Kiểm tra chất lượng cơ bản không cần pose: thời lượng, độ phân giải, FPS, độ sáng, rung.
- **Song song:** thu thập tập video thử nghiệm có đồng ý; chọn công cụ gán nhãn.

## Phase 2 — Nội dung hướng dẫn sửa
- [ ] Danh mục lỗi ra mắt và màn giải thích từng lỗi (IssueGuide).
- [ ] Thư viện bài tập beginner 7-iron, màn chi tiết bài tập.
- [ ] Trung tâm bài tập (đề xuất, lọc góc/gậy).
- [ ] Nhật ký luyện tập; coach mark giới thiệu.
- [ ] Tiếng Việt được biên tập và kiểm thử với người dùng.
- [ ] HLV/biên tập viên duyệt nội dung.

## Phase 3 — Prototype phân tích (cốt lõi MVP)
- [ ] Thử pose estimation on-device trên cả iOS và Android với cùng model (độ chính xác, tốc độ, nhiệt, pin; kiểm tra giấy phép model).
- [ ] Đánh giá plugin `camera` chính thức; viết plugin native nếu không đạt FPS/ổn định.
- [ ] Kiểm tra chất lượng có pose: toàn thân, che khuất.
- [ ] Thử tự phát hiện và cắt từng cú khi quay liên tục.
- [ ] Nhận diện pha swing với confidence; cho phép chỉnh mốc.
- [ ] Đo nhịp và thời gian pha (ưu tiên đầu tiên).
- [ ] Lớp phủ khung xương, đường tham chiếu.
- [ ] Prototype nhận diện lỗi nhóm A (Face-on và DTL).
- [ ] Đánh giá với nhãn HLV/golfer chuyên môn; đo false positive/negative theo lỗi và góc.
- [ ] Chỉ bật các lỗi đạt ngưỡng.

## Phase 4 — Tích hợp báo cáo và hướng dẫn
- [ ] Schema kết quả nhiều lỗi, mức, confidence, giới hạn.
- [ ] Luật chọn lỗi ưu tiên (tần suất + thứ tự biên tập).
- [ ] Chi tiết cú swing 3 tab: Tư thế / Toàn bộ swing / Nhịp.
- [ ] Danh sách lỗi theo phiên; "diễn biến theo pha".
- [ ] Từ lỗi → IssueGuide → bài tập (có kiểm soát, không do LLM tự sáng tác).
- [ ] Phản hồi ngay sau từng cú / tổng kết cuối phiên.
- [ ] Phản hồi người dùng (hữu ích / không hiểu / không phù hợp).
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
