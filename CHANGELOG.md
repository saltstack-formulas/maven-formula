# Changelog

## [1.0.2](https://github.com/saltstack-formulas/maven-formula/compare/v1.0.1...v1.0.2) (2020-12-16)


### Continuous Integration

* **gitlab-ci:** use GitLab CI as Travis CI replacement ([2e28efc](https://github.com/saltstack-formulas/maven-formula/commit/2e28efcac44acaf675820151ec702e8cb595d469))
* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([63279d7](https://github.com/saltstack-formulas/maven-formula/commit/63279d79e56636dd06b903abfb4cab8871a97e84))
* **pre-commit:** add to formula [skip ci] ([1c7ae30](https://github.com/saltstack-formulas/maven-formula/commit/1c7ae30ec6261ebdfbbe287ff9e3f9fe823b764c))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([b62f7ff](https://github.com/saltstack-formulas/maven-formula/commit/b62f7ff7f289186265f0fe40ca15b61fb0fea152))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([fc0bbb4](https://github.com/saltstack-formulas/maven-formula/commit/fc0bbb4f82318be4fbe333df90645777bb68d5ea))


### Styles

* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] ([a4f3d98](https://github.com/saltstack-formulas/maven-formula/commit/a4f3d98a11e9c07e004321790172162279d87abe))

## [1.0.1](https://github.com/saltstack-formulas/maven-formula/compare/v1.0.0...v1.0.1) (2020-06-03)


### Documentation

* **readme:** fix, and style updates ([ae92d5f](https://github.com/saltstack-formulas/maven-formula/commit/ae92d5f000345895e569c6b6287eb7860810100c))

# [1.0.0](https://github.com/saltstack-formulas/maven-formula/compare/v0.4.0...v1.0.0) (2020-06-02)


### Continuous Integration

* **kitchen+travis:** use latest pre-salted images ([d5e0663](https://github.com/saltstack-formulas/maven-formula/commit/d5e0663e8e957df3c80527207e417663e8ac34ae))


### Features

* **formula:** align to template formula; add ci tests ([b61f806](https://github.com/saltstack-formulas/maven-formula/commit/b61f806d8012921f2612f5d62fbf5cbe255dbd4d))


### BREAKING CHANGES

* **formula:** Major refactor of formula to bring it in alignment with the
.  As with all substantial changes, please ensure your
existing configurations work in the ways you expect from this formula.
