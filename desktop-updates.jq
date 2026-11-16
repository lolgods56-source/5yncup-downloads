[
  .[][] |
  select(.draft == false and .prerelease == false) |
  select(.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+-(macos|windows|android)$")) |
  .tag_name as $tag |
  ($tag | capture("^v(?<version>[^-]+)-(?<platform>.+)$")) as $release |
  ({"macos": "macOS-arm64.zip", "windows": "Windows-x64.zip", "android": "Android.apk"}[$release.platform]) as $suffix |
  ("5yncUp-" + $release.version + "-" + $suffix) as $asset |
  {
    tag_name,
    draft,
    prerelease,
    assets: [.assets[] | select(.name == $asset and .state == "uploaded") | {name, state, digest}]
  } |
  select(.assets | length > 0)
]
