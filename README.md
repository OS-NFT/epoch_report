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
| `coins/` | Coin images, pinned to IPFS |
| `metadata/` | Final metadata for each report |

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

Ratified and expired entries include yes-percentages from the final Koios voting summary (`drep_yes_pct`, `spo_yes_pct`, `cc_yes_pct`). A body that doesn't vote on that action type is omitted, not recorded as zero.

## Metadata rules

1. Percentages are strings, not decimal numbers.
2. No null keys. Omit the key instead.
3. Any string over 64 bytes is split into an array (`chunk64.jq`). The image is stored as `["ipfs://", "<CID>"]`.

## Validation

```
cardano-cli latest transaction build-raw --tx-in 0000000000000000000000000000000000000000000000000000000000000000#0 --fee 0 --metadata-json-file metadata/epoch-report-NNN-metadata.final.json --out-file /tmp/validate.raw
```

## Reports

| Epoch | Tier | Theme | Image CID |
|---|---|---|---|
| 653 | silver | beach | `bafkreidrx2tmdaskbewz4pyhuy2cnd4xgx4hsoskkzetoanjwwdsowqkn4` |
| 654 | gold | night | `bafkreifbuz4x3vbmk74g4vena7ylcoqb3mqvvn2fkq7z6bmry7ovdbf4dm` |
| 655 | silver | mountain | `bafkreiazjhlg7atk76nmw6z5zb3jr7u37op4ilpqrwjbinzon5uo6ugexq` |
| 656 | silver | forest | `bafkreigmumzsqduilwa7w7i6zdz6nbdcvqngzxzwxdbvhhyszqwhoo5mwu` |

Each CID is a raw sha2-256 CIDv1 of the coin file, so it can be checked against `sha256sum`.

## License

See `LICENSE`.