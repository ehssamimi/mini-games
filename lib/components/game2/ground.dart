import 'package:flame/components.dart';
import 'package:mini_games/games/game2.dart';

class Grand extends SpriteComponent with HasGameReference<MyFlameGame2>{

  Grand():super();

  @override
  Future<void> onLoad() async{
    size=Vector2(game.size.x, 200);
    position=Vector2(0, game.size.y-200);

    sprite=await Sprite.load('grand.png');

  }

  @override
  void update(double dt){
    position.x-=100*dt;
    if(position.x+size.x/2<=0){
      position.x=0;
    }
  }


}