### development version

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.1.1...master)

* Nothing yet.

### 1.1.0

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.1.0...v1.1.1)

* Add support for Rails 5.0 (#50) — [Scott Ringwelski (sgringwe)](https://github.com/sgringwe)
* Also build on Ruby 2.3.0.

### 1.1.0

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.1.0.rc2...v1.1.0)

* Bug fixes:
  * Support for sprockets-rails 3 (#46) — [Rafael Mendonça França (rafaelfranca)](https://github.com/rafaelfranca)
  * Support `Mailer#deliver!` in `AutomaticMailer` (#47) — [Julien Vanier (monkbroc)](https://github.com/monkbroc)

### 1.1.0.rc2

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.1.0.rc1...v1.1.0.rc2)

* Add support for `roadie`'s `external_asset_providers` option.

### 1.1.0.rc1

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.6...v1.1.0.rc1)

* Add support for `roadie`'s `keep_uninlinable_css` option.

### 1.0.6

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.5...v1.0.6)

* Bug fixes:
  * Support Sprockets 3's new hash length (#41)

### 1.0.5

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.4...v1.0.5)

* Enhancements:
  * Remove dependency on `rails` in favor of `railties` — [Mark J. Titorenko (mjtko)](https://github.com/mjtko)
* Bug fixes:
  * Support for Rails 4.2 default configuration — [Tomas Celizna (tomasc)](https://github.com/tomasc)
    * It's possible to inline assets with a digest (hash at the end of the filename), which is how Rails 4.2 defaults to, even when assets are not stored on disk.

### 1.0.4

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.3...v1.0.4)

* Enhancements:
  * Support for Rails 4.2 — [Ryunosuke SATO (tricknotes)](https://github.com/tricknotes)

### 1.0.3

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.2...v1.0.3)

* Bug fixes
  * Don't change `asset_providers` of a `Roadie::Document` when applying Options with no `asset_providers` set.
  * Support assets inside subdirectories.
  * Don't add `AssetPipelineProvider` when asset pipeline is unavailable (e.g. inside Rails engines).
  * Raise error when initializing `AssetPipelineProvider` with `nil` provider.

### 1.0.2

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.1...v1.0.2)

* Bug fixes
  * Don't crash on `nil` `roadie_options`

### 1.0.1

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.0...v1.0.1)

* Bug fixes
  * Inline HTML in emails without a plaintext part

### 1.0.0

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.0.pre1...v1.0.0)

* Use released version of Roadie 3.0.0

### 1.0.0.pre1

[full changelog](https://github.com/Mange/roadie-rails/compare/0000000...v1.0.0.pre1)

* First implementation
