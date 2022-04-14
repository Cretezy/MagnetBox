# MagnetBox

Puzzle game with magnets. Playable with browser (mobile supported). [Itch.io page](https://cretezy.itch.io/magnetbox). [Playable demo](https://cretezy-metal.netlify.app)

[Weekly Game Jam 248](https://itch.io/jam/weekly-game-jam-248) submission. Theme: Metal.

MIT licensed.

## Screenshots

![Title screen](https://i.imgur.com/bOqujhC.png)

![Game play](https://i.imgur.com/btsHQ5a.png)

## Level editor

- Install [Ogmo Editor 3](https://ogmo-editor-3.github.io/)
- Open the project found at [assets/levels/MagnetBox.ogmo](./assets/levels/MagnetBox.ogmo)
- Build a level, see [assets/levels/](./assets/levels/) for examples
- Load your level's `.json` from the title screen

## Credits

Tools used:
- HaxeFlixel
- Asesprite
- Ogmo Editor

Sounds:
- [Hansjörg Malthaner](http://opengameart.org/users/varkalandar): https://opengameart.org/content/rockmetal-slide
- https://www.videvo.net/sound-effect/anvil-single-hit-01/397492/
- https://www.videvo.net/sound-effect/anvil-single-strike-02/397500/
- https://mixkit.co/free-sound-effects/game/

## To build/run locally

- Install [HaxeFlixel](https://haxeflixel.com)
- Run in one terminal: `lime test html5 -debug -nolaunch --port=9000`
- Open your browser at [localhost:9000](http://localhost:9000)
- To rebuild, run the following in another terminal: `lime build html5 -debug`
- To build a release, run: `lime build html5 -minify`
