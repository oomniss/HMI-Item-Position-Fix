![title](https://cdn.modrinth.com/data/cached_images/bcd833f6980ddde5b04a7904df2d47e7b42989ce.png)

The **Hold My Items** mod adds visible first-person hands and incredible animations, but it alters item rendering, causing misalignment in many of them. This pack aims to precisely adjust the position of each in-game item, ensuring they are perfectly aligned in the player's hand.

# 🛠️ Compatibility & Synergy

We've improved how multiple packs work together. It is now possible to combine various compatible packs without causing visual misalignments, thanks to a global positioning adjustment.

| Pack | Status | Details/Notes |
| --- | --- | --- |
| **HMI 5.0** (v0.1) | ✅ **Compatible** | ----- |
| **HMI 5.1 - 5.1.1** (v0.2) | ✅ **Compatible** | ----- |
| **Actually 3D Stuff** | ✅ **Compatible** | Requires manual activation. |
| **Weskerson's 3D Items** | ✅ **Compatible** | Requires manual activation. |
| **R&V Torches** | ✅ **Compatible** | Requires manual activation. |
| **Glowing 3D Armors & Totem** | ✅ **Compatible** | Requires manual activation. |
| **Fresh Flowers and Plants** | ✅ **Compatible** | Requires manual activation. |
| **Fresh Foods** | ✅ **Compatible** | Requires manual activation. |
| **Fresh Ores And Ingots** | ✅ **Compatible** | Requires manual activation. |
| **Fresh Seeds** | ✅ **Compatible** | Requires manual activation. |
| **Ben's Bundle** | ✅ **Compatible** | Requires manual activation. |

> To enable compatibility with the 3D packages listed above, you **must** use the **Respackopts** mod. It allows you to toggle specific support in the resource pack settings menu.

![settings](https://cdn.modrinth.com/data/cached_images/5ba3cd1b4cd4b8767604add4ef9c864a5519a9e8.png)

[![Respackopts](https://img.shields.io/badge/Get-Respackopts-blue?style=for-the-badge&logo=modrinth)](https://modrinth.com/mod/respackopts)

# 📸 Visual Demonstration

See the difference the **HMI Item Position Fix** makes when using popular 3D resource packs:

| Resource Pack                | Without HMI Item Position Fix | With HMI Item Position Fix |
| ---------------------------- | ----------------------------- | -------------------------- |
| Glowing 3D Totem             | ![totem](https://cdn.modrinth.com/data/cached_images/465806011025dfe4a841b40a9ac2e9dcc7b98875.png)                              | ![totem_hmi](https://cdn.modrinth.com/data/cached_images/bbf4f047d472949ade662376c1e8a59e54f6157d.png)                       |
| Fresh Foods                  | ![foods](https://cdn.modrinth.com/data/cached_images/b4f89f85ab6cc30ab9651672afb4ec52436ebfa6.png)                           | ![foods_hmi](https://cdn.modrinth.com/data/cached_images/767a772129c9cd743b8dde866dd240dfcf72c6f0.png)                        |
| Fresh Seeds                  | ![seeds](https://cdn.modrinth.com/data/cached_images/2f9579c802f3e8a7bd47e0cc2612e529254a3ef2.png)                           | ![seeds_hmi](https://cdn.modrinth.com/data/cached_images/767397528d840f3a68ad629d6b8576877c300c27.png)                        |
| Fresh Ores and Ingots        | ![ores](https://cdn.modrinth.com/data/cached_images/01bc7cbee12dcda82a2c6459a3341befa5fa43f7.png)                           | ![ores_hmi](https://cdn.modrinth.com/data/cached_images/91d30fec20c28c28d29d0b2f4c6804b04f30f6d5.png)                        |
| Ben's Bundle                 | ![bundles](https://cdn.modrinth.com/data/cached_images/c95565e3d8592dbba7c539793cd17ecf45c7445c.png)                           | ![bundles_hmi](https://cdn.modrinth.com/data/cached_images/f388ce3538d1f9409b6042423d0071d2af2405d2.png)                        |
| R&V Torches                  | ![rvtorches](https://cdn.modrinth.com/data/cached_images/997e1fff46e7f259a7ef09b6cb9d590d7ea6e83c.png)                           | ![rvtorches_hmi](https://cdn.modrinth.com/data/cached_images/885206ae25b38eee6f5aa270fa621f7438c4009e.png)                        |
| Weskerson's 3D Items (W3DI)  | ![w3di](https://cdn.modrinth.com/data/cached_images/82d61cb84fdefce3575d1033d1f2f8614e521922.png)                           | ![w3di_hmi](https://cdn.modrinth.com/data/cached_images/b2d5a401468106c3da65226c567b3a0e69cfe0b4.png)                        |
| Actually 3D Stuff (A3DS)     | ![a3ds](https://cdn.modrinth.com/data/cached_images/2228837d9081ee3e7171a7b5f4197174e7c3b8fc.png)                           | ![a3ds_hmi](https://cdn.modrinth.com/data/cached_images/16549358687751f42bbe0bb2c5055f0cffd02328.png)                        |

# 📥 Load Order & Requirements

To ensure correct positioning and avoid physics glitches, please follow this load order (top of the list = bottom of the resource pack menu):

1. **Other 3D Packs** (Fresh Foods, Seeds, Torches, etc.)
2. **Actually 3D Stuff**
3. **Weskerson's 3D Items**
4. **HMI Item Position Fix** (Always at the bottom)

![load order](https://cdn.modrinth.com/data/cached_images/1fd662e6a78098d52392897b1324f05216d42924.png)

### ⚠️ Important Notes
* **Incompatibility:** Do not use `Actually 3D Stuff` and `Fresh Flowers and Plants` together.
* **Loading Priority:** When using `A3DS + W3DI`, the `A3DS` pack must be placed above W3DI.

Found a bug or have a suggestion? Join our [Discord](https://discord.com/channels/1453136992534663319/1453138060538675272) or report it in the [HMI Addon Channel](https://discord.com/channels/1346575587787014326/1469563796648366234) or on the [github project](https://github.com/murillofacchini/HMI-Item-Position-Fix/issues)!
