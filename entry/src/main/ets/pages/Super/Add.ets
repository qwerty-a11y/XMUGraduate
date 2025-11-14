import router from '@ohos.router';
import { url } from '@kit.ArkTS';

// 定义提交数据的接口
interface SubmitData {
  role: string;
  account: string;
  majorClass: string;
  password: string;
  dataExportPermission: boolean;
}

@Entry
@Component
struct NewAddPage {
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
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
            router.pushUrl({ url: 'pages/Super/Main' },router.RouterMode.Single);
          });


        Text('新添')
          .fontSize(20)
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
        Text('他/她是：')
          .width('96%')
          .fontSize(16)
          .margin({ top: 32 });

        Row() {
          Text('教师')
            .fontSize(16)
            //.margin({ left: 32 });
          Toggle({ type: ToggleType.Switch, isOn: this.isTeacher })
            .onChange((isOn: boolean) => {
              this.isTeacher = isOn;
            });
          Text('学生')
            .fontSize(16)
            .margin({ left: 32 });
          Toggle({ type: ToggleType.Switch, isOn: !this.isTeacher })
            .onChange((isOn: boolean) => {
              this.isTeacher = !isOn;
            });
        }
        .width('80%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 8 });

        Text('账号：')
          .fontSize(16)
          .width('96%')
          .margin({ top: 16});
        TextInput({ placeholder: '请输入他/她学工号' })
          .width('90%')
          .height(40)
          .margin({ left: 16, right: 16, top: 4 })
          .onChange((value: string) => {
            this.account = value;
          });

        // 专业班级输入框，仅学生可见

          Text('单位：')
            .width('96%')
            .fontSize(16)
            .margin({ top: 16});
          TextInput({ placeholder: '请输入院系，学生还要输入班级' })
            .width('90%')
            .margin({ left: 16, right: 16, top: 4 })
            .onChange((value: string) => {
              this.majorClass = value;
            });


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
            router.pushUrl({ url: 'pages/Super/Main' },router.RouterMode.Single);
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