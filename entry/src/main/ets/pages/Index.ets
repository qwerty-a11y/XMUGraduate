import { AnimatorParams } from "@kit.MediaLibraryKit"
import {Waiting} from '../components/Login/Waiting'
import {Login} from '../components/Login/Login'


@Entry
@Component
struct Index {
  @State LoginType:number=0
  private isFirstLoad:boolean = true
  animateOutParam:AnimateParam = {
    duration:500,
    curve:Curve.EaseIn
  }
  animateInParam:AnimateParam={
    delay:250,
    duration:500,
    curve:Curve.EaseOut
  }
  mainAnimationsFirst = TransitionEffect.asymmetric(
    TransitionEffect.IDENTITY.animation(this.animateInParam),
    TransitionEffect.translate({x:'-100%'}).animation(this.animateOutParam)
  )
  mainAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'-100%'}).animation(this.animateInParam),
    TransitionEffect.translate({x:'-100%'}).animation(this.animateOutParam)
  )
  childAnimations = TransitionEffect.asymmetric(
    TransitionEffect.translate({x:'100%'}).animation(this.animateInParam),
    TransitionEffect.translate({x:'100%'}).animation(this.animateOutParam)
  )
  @State activeViewIndex:number = 0;

  TriggerAnimate(index:number):void{
    this.activeViewIndex=index
    this.isFirstLoad=false
  }

  @Builder
  LoginView(){
    if(this.activeViewIndex==0) {
      if (this.isFirstLoad){
        Login({LoginType:this.LoginType})
          .transition(this.mainAnimationsFirst)
          .margin({
            left:'10%',
            right:'10%',
            top:'10%'
          })
      } else {
        Login({LoginType:this.LoginType})
          .transition(this.mainAnimations)
          .margin({
            left:'10%',
            right:'10%',
            top:'10%'
          })
      }
    } else if (this.activeViewIndex==1) {
      Waiting().transition(this.childAnimations)
    }
  }


  build() {
    RelativeContainer() {
      Image($r('app.media.Title_background'))
        .objectFit(ImageFit.Fill)
        .borderRadius({
          topLeft:'20%',
          topRight:'20%'
        })
        .margin({
          top:'20%'
        })
      Image($r('app.media.logo'))
        .id('TitleLogo')
        .width('50%')
        .objectFit(ImageFit.Contain)
        .margin({
          top:'30%',
          left:'15%',
          right:'15%'
        })
        .alignRules({
          middle:{anchor:'__container__',align:HorizontalAlign.Center}
        })
      Column(){
        this.LoginView()
      }
        .alignRules({
          top:{anchor:"TitleLogo",align:VerticalAlign.Bottom}
        })
        .margin({
          top:'5%'
        })


    }
    .height('100%')
    .width('100%')
  }
}