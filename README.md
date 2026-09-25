# epoch_report

Epoch Report NFTs from the WEED Cardano stake pool. One NFT per epoch records that epoch's on-chain governance actions, with a generated commemorative coin as the image.

- **Policy ID:** `f8b9cb66507bb95a96dc7523ecfe15fd7e5b4f24297e36553fd93c1d` (time-locked, expires 2031-09-10)
- **Asset names:** `EpochReportNNN` (e.g. `EpochReport656`)
- **Metadata standard:** CIP-25 (label 721)
- **Governance data source:** Koios API

## Contents

| Path | Purpose |
|---|---|
| `scripts/generate_epoch_coin.sh` | ImageMagick coin generator |
| `scripts/chunk64.jq` | Splits metadata strings over 64 bytes into arrays |
| `scripts/search.sh` | Searches the minted metadata (both schemas) |
| `coins/` | Coin images, pinned to IPFS |
| `metadata/` | Minted metadata for each report, byte-identical to the file submitted on-chain |
| `manifest.json` | Index of every report: asset, mint tx, schema, tier, theme, image, metadata SHA-256 |

## Coins

```
./generate_epoch_coin.sh <epoch_number> <silver|gold> [theme]
```

Themes: forest, desert, beach, ocean, mountain, night (random if omitted).

**Tiers:** silver for standard epochs. Gold for sequential digit runs in either direction (e.g. 654), round hundreds (e.g. 700), and repdigits (e.g. 777).

## Metadata schema

Each report includes `name`, `image`, `mediaType`, `tier`, `theme`, `epoch`, and `governance`. Governance actions are sorted into five buckets:

- **new:** proposed this epoch
- **active:** proposed in an earlier epoch and still open
- **ratified**, **enacted**, **expired:** status changed this epoch

Entries with a final vote carry yes-percentages from the Koios voting summary. A body that doesn't vote on that action type is omitted, not recorded as zero.

### v2 (654 onward)

Each governance item is `title`, `type`, and, where there was a final vote, `votes` with `cc`, `drep`, `spo` keys.

```json
{ "title": "...", "type": "TreasuryWithdrawals", "votes": { "cc": "71.43", "drep": "65.18" } }
```

Explorers display metadata keys alphabetically, not in file order. v2 key names are chosen so each item reads title, type, votes. The bucket an item sits in already implies the epoch, so there is no per-item epoch field.

### v1 (653 only)

Yes-percentages are flat fields (`drep_yes_pct`, `spo_yes_pct`, `cc_yes_pct`) plus `ratified_epoch` or `expired_epoch`. 653 was minted in this layout and stays as it is.

## Metadata rules

1. Percentages are strings, not decimal numbers.
2. No null keys. Omit the key instead.
3. Any string over 64 bytes is split into an array (`chunk64.jq`). The image is stored as `["ipfs://", "<CID>"]`.
4. To read a split string, join the array pieces with nothing in between (`join("")`). Explorers such as adastat and pool.pm show these arrays as comma-separated lists (e.g. `administered , by Intersect`). That comma is display only and is not in the data.

## Search

```
scripts/search.sh [term]
```

Case-insensitive match on title, type, or bucket. With no term, lists every governance item. Output columns: epoch, bucket, type, full title, votes, mint tx (first 12 characters). Reads both schemas and applies rule 4. Requires `jq`.

```
$ scripts/search.sh ikigai
656  expired  TreasuryWithdrawals  Reimburse Ikigai Info Governance Action Deposit  drep=65.18 cc=71.43  4d730e7dd46b
```

## Validation

Before minting:

```
cardano-cli latest transaction build-raw --tx-in 0000000000000000000000000000000000000000000000000000000000000000#0 --fee 0 --metadata-json-file metadata/epoch-report-NNN-metadata.json --out-file /tmp/validate.raw
```

After minting, each file's SHA-256 should match `manifest.json`:

```
sha256sum metadata/*.json
```

## Reports

| Epoch | Tier | Theme | Image CID |
|---|---|---|---|
| 653 | silver | beach | `bafkreidrx2tmdaskbewz4pyhuy2cnd4xgx4hsoskkzetoanjwwdsowqkn4` |
| 654 | gold | night | `bafkreifbuz4x3vbmk74g4vena7ylcoqb3mqvvn2fkq7z6bmry7ovdbf4dm` |
| 655 | silver | mountain | `bafkreiazjhlg7atk76nmw6z5zb3jr7u37op4ilpqrwjbinzon5uo6ugexq` |
| 656 | silver | forest | `bafkreigmumzsqduilwa7w7i6zdz6nbdcvqngzxzwxdbvhhyszqwhoo5mwu` |

Each CID is a raw sha2-256 CIDv1 of the coin file, so it can be checked against `sha256sum`.

## Mints

All minted 2026-09-24, quantity 1 each.

| Epoch | Asset | Schema | Mint tx |
|---|---|---|---|
| 653 | `EpochReport653` | v1 | `1f1744f7e8f09711bbb6257a333e9a882badbedf89974769483377941dd8dfda` |
| 654 | `EpochReport654` | v2 | `0e48016771fdbb0790cfd1d3307cb6b8f838af4a9b3fdae269d3b278898f707c` |
| 655 | `EpochReport655` | v2 | `3c2a9dac36caddba3740e2e2ec062f2607d1f44fcc43534bb06f63e351052e17` |
| 656 | `EpochReport656` | v2 | `4d730e7dd46b90cf09eac7b7c056217202224110f7949b8e44d314491b681fdd` |

## License

See `LICENSE`.