// launch.ets
import { Baoyanstartbg,Baoyanlogo } from '../components/Baoyanstart';

@Entry
@Component
struct Launch {
  build() {
    // 使用Stack实现背景图和logo的叠加效果
    Stack() {
      // 背景图组件 - 占满全屏
      Baoyanstartbg()
        .width('100%')
        .height('100%');

      // Logo组件 -
      Baoyanlogo()
        .width(200)
        .height(200)
        .margin({ top: '-30%' });
    }
    .width('100%')
    .height('100%');
  }
}
