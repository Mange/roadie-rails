### development version

[full changelog](https://github.com/Mange/roadie-rails/compare/v1.0.3...master)

* Nothing yet

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
