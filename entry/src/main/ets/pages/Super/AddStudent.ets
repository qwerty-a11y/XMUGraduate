import router from '@ohos.router';
import { url } from '@kit.ArkTS';

@Entry
@Component
struct NewAddPage {
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @Prop image_download: ResourceStr = $r('app.media.Download');
  @Prop image_world: ResourceStr = $r('app.media.world');
  @State isTeacher: boolean = true; // 标记是教师还是学生，默认教师
  @State account: string = ''; // 账号
  @State majorClass: string = ''; // 专业班级
  @State dataExportPermission: boolean = false; // 数据导出权限状态

  build() {
    Column() {
      // 头部区域
      Row() {
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          });

        Text('新添学生')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .flexGrow(1)
          .textAlign(TextAlign.Center);
        Text('') // 占位，保持标题居中
          .width(24)
          .height(24)
          .margin({ right: 16 });
      }
      .width('100%')
      .height(56)
      .backgroundColor('#ffffff');

      // 表单区域
      Column() {
        Text('身份：学生')
          .width('96%')
          .fontSize(16)
          .margin({ top: 32,bottom:10 });

        Column(){
          Row(){
            Text('导入excel表格，格式见文档')
              .fontSize(14)
              .flexGrow(1)
            Column() {
              Image(this.image_world)
                .width(24)
            }
              .width(25)
          }
          .width('96%')
          .margin({bottom:10})

          Row(){
            Image(this.image_download)
              .height(52)
          }
          .justifyContent(FlexAlign.Center)
          .width('96%')
          .backgroundColor('#ffdedcdc')
          .borderRadius(20)
          .height(60)

        }

        Text(`生成密码为：123456`)
          .fontSize(16)
          .width('96%')
          .margin({ top: 32 });

        Row() {
          Text('数据导出权限')
            .fontSize(16)
            .margin({ top: 16,bottom:10 });
          Toggle({ type: ToggleType.Switch, isOn: this.dataExportPermission })
            .margin({ top: 16, right: 16 })
            .onChange((isOn: boolean) => {
              this.dataExportPermission = isOn;
            });
        }
        .width('96%')

        Button('确定')
          .width(120)
          .height(40)
          .backgroundColor('#87E8DE')
          .borderRadius(20)
          .margin({ top: 24, bottom: 32 })
          .onClick(() => {
            router.back()
          });
        // .onClick(() => {
        //   // 确定按钮点击逻辑，使用声明的接口
        //   const submitData: SubmitData = {
        //     role: this.isTeacher ? '教师' : '学生',
        //     account: this.account,
        //     majorClass: this.majorClass,
        //     password: '123456',
        //     dataExportPermission: this.dataExportPermission
        //   };
        //   console.info('提交的新添数据：', submitData);
        //   // 这里可以添加后续操作逻辑，如调用接口保存数据等
        // });


      }
      .width('90%')
      .backgroundColor('#ffffff')
      .padding({left:10,right:10})
      .margin({ left: 16, right: 16,top:20 })
      .borderRadius(20)
      .shadow({
        radius: 4,
        color: '#ff5a5555',
        offsetX: 2,
        offsetY: 4
      });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F8FA');
  }
}