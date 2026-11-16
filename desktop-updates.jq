[
  .[][] |
  select(.draft == false and .prerelease == false) |
  select(.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+-(macos|windows)$")) |
  .tag_name as $tag |
  ($tag | capture("^v(?<version>[^-]+)-(?<platform>.+)$")) as $release |
  (if $release.platform == "macos" then "macOS-arm64" else "Windows-x64" end) as $suffix |
  ("5yncUp-" + $release.version + "-" + $suffix + ".zip") as $asset |
  {
    tag_name,
    draft,
    prerelease,
    assets: [.assets[] | select(.name == $asset and .state == "uploaded") | {name, state}]
  } |
  select(.assets | length > 0)
]
