

import 'package:flame/components.dart';

class Bird extends SpriteComponent{


  Bird():super(position: Vector2(100, 100),size: Vector2(60, 40));


  //physical word properties
  double velocity=0;
  final double gravity=400;
  final double jumpStrength=-300;

  @override
  Future<void> onLoad() async{
    sprite=await Sprite.load('bird.png');
  }


  void flap(){
velocity=jumpStrength;
  }

  void update(double dt){
velocity+=gravity*dt;
position.y+=velocity*dt;

  }

}