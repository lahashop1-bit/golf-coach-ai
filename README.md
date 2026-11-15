# Golf Coach AI

Ứng dụng huấn luyện golf cá nhân trên iPhone và Android, hỗ trợ đa ngôn ngữ, ưu tiên trải nghiệm tiếng Việt tự nhiên cho người mới chơi.

> **Trọng tâm MVP:** quay/nhập video → AI phân tích tư thế và cú swing → nêu lỗi → hướng dẫn cách sửa → luyện lại.
>
> **Mục tiêu:** giúp người chơi hiểu cú swing của mình, biết lỗi nào nên sửa trước và có bài tập cụ thể để cải thiện an toàn, có hệ thống.

## Trạng thái dự án

- Giai đoạn: Lát 1 (thu video và thư viện) chạy được trên iPhone. **Chưa có phân tích AI**: tab Tư thế/Nhịp hiển thị "Chưa phân tích". Xem [Roadmap](docs/DEVELOPMENT_ROADMAP.md).
- Nền tảng: iOS và Android (Flutter + module native cho camera và AI). Xem [Platform Decision](docs/PLATFORM_DECISION.md).
- Ngôn ngữ ra mắt dự kiến: Tiếng Việt (vi-VN), English (en), 한국어 (ko-KR).
- Đối tượng đầu tiên: người mới chơi golf; hỗ trợ người chơi trung cấp ở các giai đoạn sau.
- Tên Golf Coach AI là tên làm việc, chưa phải quyết định thương hiệu cuối cùng.

## Chạy ứng dụng

Yêu cầu: Flutter 3.47+, Xcode 26+ (iOS 15+), Android SDK (API 26+).

```sh
flutter pub get
flutter run -d "iPhone 17"            # iOS simulator (không có camera: dùng "Nhập video")
flutter run -d <tên iPhone thật>      # cần chọn Team ký trong ios/Runner.xcworkspace
flutter build apk --debug --target-platform android-arm64   # Android trên Apple Silicon
```

Sinh lại code sau khi sửa:
- Bảng DB (`lib/data/db/database.dart`): `dart run build_runner build`
- Chuỗi giao diện (`lib/l10n/*.arb`): `flutter gen-l10n`
- Kênh native (`packages/capture/pigeons/`): xem [packages/capture/README.md](packages/capture/README.md)

Kiểm thử:

```sh
flutter test                          # unit + widget
ffmpeg -f lavfi -i testsrc=size=720x1280:rate=60 -t 3 -pix_fmt yuv420p /tmp/swing60.mp4
flutter test integration_test -d "iPhone 17" --dart-define=PROBE_VIDEO=/tmp/swing60.mp4
```

Integration test chạy plugin native thật, DB thật và trình phát video thật trên simulator.

Cấu trúc mã:

| Thư mục | Nội dung |
|---|---|
| `lib/app/` | App, router 4 tab, theme, providers, nhãn enum |
| `lib/domain/` | Enum chuẩn (theo DATABASE_SCHEMA), kiểm tra chất lượng video |
| `lib/data/` | drift DB, repository, kho video |
| `lib/features/<tên>/` | Màn hình theo tính năng |
| `lib/l10n/` | ARB vi/en/ko |
| `packages/capture/` | Plugin native (Swift/Kotlin, Pigeon): đọc FPS thật, thời lượng, ảnh bìa |

## Tài liệu dành cho Claude Code

Đọc theo thứ tự:

1. [CLAUDE.md](CLAUDE.md) — quy tắc làm việc bắt buộc cho AI coding agent.
2. [PRD](docs/PRODUCT_REQUIREMENTS.md) — yêu cầu sản phẩm và phạm vi MVP.
3. [UI/UX Spec](docs/UI_UX_SPEC.md) — luồng và màn hình ứng dụng.
4. [Golf Features](docs/GOLF_FEATURES.md) — chức năng golf và quay swing.
5. [AI Analysis](docs/AI_ANALYSIS_SPEC.md) — phân tích video, giới hạn và cách phản hồi.
6. [Localization](docs/I18N_L10N_SPEC.md) — kiến trúc đa ngôn ngữ và quy chuẩn tiếng Việt.
7. [Vietnamese Golf Glossary](docs/VIETNAMESE_GOLF_GLOSSARY.md) — thuật ngữ Anh–Việt thống nhất.
8. [Architecture](docs/TECHNICAL_ARCHITECTURE.md) — kiến trúc kỹ thuật đề xuất.
9. [Database Schema](docs/DATABASE_SCHEMA.md) — mô hình dữ liệu.
10. [Roadmap](docs/DEVELOPMENT_ROADMAP.md) — thứ tự triển khai.
11. [Acceptance Criteria](docs/ACCEPTANCE_CRITERIA.md) — tiêu chí nghiệm thu.
12. [Reference Feature Analysis](docs/REFERENCE_FEATURE_ANALYSIS.md) — phân tích tính năng từ ảnh tham chiếu (cập nhật theo từng lô ảnh).
13. [Platform Decision](docs/PLATFORM_DECISION.md) — ADR chọn Flutter + module native cho iOS và Android.

## Nguyên tắc sản phẩm

- Thiết kế độc lập; không sao chép mã nguồn, hình ảnh, nhận diện thương hiệu hoặc bố cục độc quyền của ứng dụng khác.
- Mọi hướng dẫn phải dễ hiểu, thực hành được và phù hợp trình độ người chơi.
- AI không được khẳng định chắc chắn khi góc quay, ánh sáng hoặc chất lượng video không đủ.
- Không chẩn đoán bệnh hoặc đưa ra lời khuyên y tế.
- Không mặc định rằng một kiểu swing duy nhất phù hợp với mọi người.
- Người dùng phải kiểm soát video, dữ liệu cá nhân và việc tải dữ liệu lên máy chủ.

## Tham chiếu nghiên cứu ban đầu

Người dùng cung cấp hai ảnh chụp GolfFix trên iPhone:
- Màn hình ghi hình: lựa chọn Face-on / DTL, Iron / Driver, Orientation Right, FPS 60, Timer OFF, My Swing / Other Swing, Guide, Start Recording, Flip.
- Màn hình thiết lập chế độ: Swing Analysis Mode / Self Record Mode, số lần swing, bật/tắt phản hồi ngay sau từng cú đánh và thiết lập thời lượng phản hồi.

Đây là tham chiếu về nhu cầu và luồng sử dụng, không phải yêu cầu sao chép giao diện. Xem [UI/UX Spec](docs/UI_UX_SPEC.md).

## Bảo mật repository

Repository hiện đang để Public theo lựa chọn tạm thời của chủ dự án. Trước khi đưa API key, thông tin cá nhân, dữ liệu người dùng, cấu hình môi trường hoặc tài liệu nhạy cảm vào đây, hãy chuyển repository sang Private và kiểm tra lịch sử commit. Không bao giờ commit secrets.
