# epoch_report

Governance-history NFTs from the WEED Cardano stake pool, in two series:

- **Epoch Reports:** one NFT per epoch recording that epoch's on-chain governance actions, with a generated commemorative image (a coin; 661 is a hand).
- **Monthly Reports:** one NFT per calendar month summarising governance across the month, with a scroll-calendar image.

Both series share one policy.

- **Policy ID:** `f8b9cb66507bb95a96dc7523ecfe15fd7e5b4f24297e36553fd93c1d` (time-locked, expires 2031-09-10)
- **Asset names:** `EpochReportNNN` (e.g. `EpochReport658`) and `MonthlyReportYYYYMM` (e.g. `MonthlyReport202609`)
- **Metadata standard:** CIP-25 (label 721)
- **Governance data source:** Koios API

## Contents

| Path                               | Purpose                                                                                               |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `scripts/generate_epoch_coin.sh`   | ImageMagick coin generator (Epoch Reports)                                                            |
| `scripts/generate_epoch_hand.sh`   | ImageMagick hand generator (Epoch Report 661)                                                         |
| `scripts/generate_monthly_coin.sh` | Scroll-calendar image generator (Monthly Reports)                                                     |
| `scripts/build_epoch_report.sh`    | Builds an Epoch Report's metadata                                                                     |
| `scripts/chunk64.jq`               | Splits metadata strings over 64 bytes into arrays                                                     |
| `scripts/search.sh`                | Searches the minted metadata (both series, both epoch schemas)                                        |
| `coins/`                           | Report images, pinned to IPFS                                                                         |
| `metadata/`                        | Minted metadata for each report, byte-identical to the file submitted on-chain                        |
| `manifest.json`                    | Index of every report: series, asset, mint tx, schema, tier or design, theme, image, metadata SHA-256 |

## Coins

```
./generate_epoch_coin.sh <epoch_number> <silver|gold> [theme]
```

Themes: forest, desert, beach, ocean, mountain, night, aurora, lagoon, meadow, savanna, reef, storm (random if omitted). Theme details sit in the corners, outside the coin (rim radius 75 around the centre of the 200x200 grid).

**Tiers:** silver for standard epochs. Gold for sequential digit runs in either direction (e.g. 654), round hundreds (e.g. 700), and repdigits (e.g. 777).

### Hand design (661)

Epoch Report 661 used a pixel-art open hand, palm up, in place of the coin, on the same 200x200 grid and theme backgrounds as the coins. The epoch number sits exactly where the coin's number was. Hands have no tier. 662 returned to the coin.

```
./generate_epoch_hand.sh <epoch_number> [theme]
```

Theme defaults to beach. The current version supports beach only.

Monthly Reports use a different image: a pixel-art Roman scroll calendar in the same style as the coins, with the days on which an epoch boundary falls shown as red numbered cells, set on background bands coloured by season. Monthly images have no tier or theme.

## Metadata schema

Each Epoch Report includes `name`, `image`, `mediaType`, `tier`, `theme`, `epoch`, and `governance`. A hand-design report (661) has `design` (e.g. `hand`) in place of `tier`, in the same position. `build_epoch_report.sh` writes it when given `--design`; without the flag, its output is unchanged:

```
./build_epoch_report.sh 661 --theme beach --cid <CID> --design hand -o epoch-report-661-metadata.json
```

Governance actions are sorted into five buckets:

- **new:** proposed this epoch
- **active:** proposed in an earlier epoch and still open
- **ratified**, **enacted**, **expired:** status changed this epoch

Entries with a final vote carry yes-percentages from the Koios voting summary. A body that doesn't vote on that action type is omitted, not recorded as zero.

### v2 (654 onward)

Each governance item is `title`, `type`, and, where there was a final vote, `votes` with `cc`, `drep`, `spo` keys.

```
{ "title": "...", "type": "TreasuryWithdrawals", "votes": { "cc": "71.43", "drep": "65.18" } }
```

Explorers display metadata keys alphabetically, not in file order. v2 key names are chosen so each item reads title, type, votes. The bucket an item sits in already implies the epoch, so there is no per-item epoch field.

### v1 (653 only)

Yes-percentages are flat fields (`drep_yes_pct`, `spo_yes_pct`, `cc_yes_pct`) plus `ratified_epoch` or `expired_epoch`. 653 was minted in this layout and stays as it is.

### Monthly Reports

A Monthly Report covers one calendar month, from the 1st at 00:00 UTC to the last day at 23:59 UTC, regardless of where epoch boundaries fall. It carries a context line on the month's start and end, and sorts governance actions into six buckets:

- **open at start:** still open when the month began
- **new:** proposed during the month
- **ratified**, **enacted**, **expired:** status changed during the month
- **open at end:** still open when the month ended

Governance items use the v2 item layout (`title`, `type`, `votes`).

## Metadata rules

1. Percentages are strings, not decimal numbers.
2. No null keys. Omit the key instead.
3. Any string over 64 bytes is split into an array (`chunk64.jq`). The image is stored as `["ipfs://", "<CID>"]`.
4. To read a split string, join the array pieces with nothing in between (`join("")`). Explorers such as adastat and pool.pm show these arrays as comma-separated lists (e.g. `administered , by Intersect`). That comma is display only and is not in the data.

## Search

```
scripts/search.sh [term]
```

Case-insensitive match on title, type, or bucket. With no term, lists every governance item across both series. Output columns: report (epoch number, or asset name for Monthly Reports), bucket, type, full title, votes, mint tx (first 12 characters). Reports are matched to `manifest.json` by asset name. Reads both epoch schemas and applies rule 4. Requires `jq`.

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

### Epoch Reports

| Epoch | Tier / design | Theme    | Image CID                                                     |
| ----- | ------------- | -------- | ------------------------------------------------------------- |
| 653   | silver        | beach    | `bafkreidrx2tmdaskbewz4pyhuy2cnd4xgx4hsoskkzetoanjwwdsowqkn4` |
| 654   | gold          | night    | `bafkreifbuz4x3vbmk74g4vena7ylcoqb3mqvvn2fkq7z6bmry7ovdbf4dm` |
| 655   | silver        | mountain | `bafkreiazjhlg7atk76nmw6z5zb3jr7u37op4ilpqrwjbinzon5uo6ugexq` |
| 656   | silver        | forest   | `bafkreigmumzsqduilwa7w7i6zdz6nbdcvqngzxzwxdbvhhyszqwhoo5mwu` |
| 657   | silver        | beach    | `bafkreiaeqohamecnuv6dp4p7ybi2eearw65rib6iwucazh7qnrw6veiwwi` |
| 658   | silver        | ocean    | `bafkreiceuodshalhgtr2x7s5a6vqkef4i64b2dycsjn32ldwd56n6vvvm4` |
| 659   | silver        | aurora   | `bafkreia4xeevwrkqw5nusvgy37azclh6evt6usnz6dsn3it5g736d5mhzm` |
| 660   | silver        | lagoon   | `bafkreicsb2cnqlhrz4mt7iy6voo66mll2agauvcwd7e5iz3aisdfepobrq` |
| 661   | hand          | beach    | `bafkreiaokz4plz45hdbhmp2qssf6upudnli57ihjdwghzvcnjnx7v2thom` |
| 662   | silver        | savanna  | `bafkreice4upopynmr4qxccw4yy26kbrtdbmilw47tecs6x4xvp6xjd2rau` |

### Monthly Reports

| Month   | Image CID                                                     |
| ------- | ------------------------------------------------------------- |
| 2026-09 | `bafkreif22asjkd6eylxq6qp4ljsqsfss5cfg2ggzqecadjsuwo7uo4cub4` |

Each CID is a raw sha2-256 CIDv1 of the image file, so it can be checked against `sha256sum`.

## Mints

Quantity 1 each. Dates are UTC.

| Report  | Asset                 | Schema  | Minted     | Mint tx                                                            |
| ------- | --------------------- | ------- | ---------- | ------------------------------------------------------------------ |
| 653     | `EpochReport653`      | v1      | 2026-09-24 | `1f1744f7e8f09711bbb6257a333e9a882badbedf89974769483377941dd8dfda` |
| 654     | `EpochReport654`      | v2      | 2026-09-24 | `0e48016771fdbb0790cfd1d3307cb6b8f838af4a9b3fdae269d3b278898f707c` |
| 655     | `EpochReport655`      | v2      | 2026-09-24 | `3c2a9dac36caddba3740e2e2ec062f2607d1f44fcc43534bb06f63e351052e17` |
| 656     | `EpochReport656`      | v2      | 2026-09-24 | `4d730e7dd46b90cf09eac7b7c056217202224110f7949b8e44d314491b681fdd` |
| 657     | `EpochReport657`      | v2      | 2026-10-01 | `8fb0444332693da640af6a2708873e1d85a2e3a3e5569162751273a0ae08fdbb` |
| 658     | `EpochReport658`      | v2      | 2026-10-06 | `9d0f3395070e2c0fc0ad75fd4ba45b8d28360a4de237b81ecd15b250253b5549` |
| 2026-09 | `MonthlyReport202609` | monthly | 2026-10-06 | `5f64f30e7f4c3b59707ce3e4fe109727315b0b7bf507b5d5987d835ab0288efa` |
| 659     | `EpochReport659`      | v2      | 2026-10-12 | `d3b1bf0b5e27b03b96115f6c19c534a297f1eaf7c35facd4ee5dcf64bef9077d` |
| 660     | `EpochReport660`      | v2      | 2026-10-12 | `98b36be4725190a9a5beb44cd8c0cd4d27f5b470bc7594275907f47c498c1938` |
| 661     | `EpochReport661`      | v2      | 2026-10-20 | `5bad8b478851c0daba29ecbb576c01f90ead388393df8ed0fa781f90e5b65a55` |
| 662     | `EpochReport662`      | v2      | 2026-10-28 | `f4c58b6d801c78e98d5216f73b46ae9e275251cc7bea29ea9eea7a1881fff5ce` |

## Provenance notes

- **654 vote figures:** after Epoch Report 654 was minted, Koios revised one of its SPO yes figures from 54.48 to 54.30. The on-chain metadata keeps 54.48, the figure Koios reported at mint time. Rebuilding 654 today will show that difference; it is a change in the source data, not in the builder.
- **662 PFMS title:** Koios had no parsed metadata for this treasury withdrawal (`gov_action1wfy3vzxurfgq6wrpxg2qdx3t6wm7ng8xwr26h47kxa8xhd20cr5qqz0wzfc`) at build time, so the builder could not find a title. The title was taken from the proposal's anchor document, after confirming the document's blake2b-256 matched the on-chain anchor hash `09e2ef6f02fd53aab203c872f082f888e8c53b383377a13e3b71eb08550be389`, and was split at 64 bytes by the same rule as other titles.

## License

See `LICENSE`.
