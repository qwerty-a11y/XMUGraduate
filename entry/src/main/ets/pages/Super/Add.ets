import router from '@ohos.router';
import { url } from '@kit.ArkTS';
import http from '@ohos.net.http';
import { DynamicData, StaticData } from '../../constants';
import { BusinessError } from '@kit.BasicServicesKit';
import promptAction from '@ohos.promptAction';
import { LengthMetrics } from '@kit.ArkUI';

// 定义请求数据接口
interface StudentInfoRequest {
  school_id: string;
  name: string;
  department: string;
  major: number;
  academy_score: number;
  cet4: number;
  cet6: number;
}

// 定义教师请求数据接口
interface TeacherInfoRequest {
  school_id: string;
  name: string;
  department: string;
}

@Entry
@Component
struct NewAddPage {
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @State isTeacher: boolean = true; // 标记是教师还是学生，默认教师
  @State account: string = ''; // 账号
  @State name:string =''
  @State major: number = 0; // 专业班级
  @State score: number = 0;
  @State cet: number[] = [-1,-1];
  private MajorList:string[] = ['计算机科学与技术','软件工程','人工智能','网络安全']
  //@State dataExportPermission: boolean = false; // 数据导出权限状态

  async submitAccountInfo(): Promise<boolean> {
    const httpRequest = http.createHttp();

    try {
      // 根据账户类型选择不同的URL和请求数据
      const url = this.isTeacher
        ? `${StaticData.ServerURL}/api/account/admin/create/teacher/`
        : `${StaticData.ServerURL}/api/account/admin/create/student/`;

      let requestData:StudentInfoRequest|TeacherInfoRequest;

      if (!this.isTeacher) {
        // 学生类型
        requestData = {
          school_id: this.account,
          name: this.name,
          department: '信息学院-'+this.MajorList[this.major],
          academy_score: this.score,
          cet4: this.cet[0] !== -1 ? this.cet[0] : 0,
          cet6: this.cet[1] !== -1 ? this.cet[1] : 0
        } as StudentInfoRequest;
      } else {
        // 教师类型
        requestData = {
          school_id: this.account,
          name: this.name,
          department: '信息学院'
        } as TeacherInfoRequest;
      }

      const response: http.HttpResponse = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': `Token ${DynamicData.token}`
          },
          extraData: JSON.stringify(requestData),
          connectTimeout: 5000
        }
      );

      // 检查状态码
      if (response.responseCode === 200) {
        promptAction.showToast({
          message: `${this.isTeacher ? '教师' : '学生'}账户创建成功`,
          duration: 2000
        });
        return true;
      } else {
        promptAction.showToast({
          message: `创建失败，状态码: ${response.responseCode}`,
          duration: 2000
        });
        return false;
      }

    } catch (error) {
      const err = error as BusinessError;
      console.log(`账户信息提交失败: ${err.message}`);
      promptAction.showToast({
        message: '网络请求失败，请检查网络连接',
        duration: 2000
      });
      return false;
    }
  }

  // 验证表单数据
  validateForm(): boolean {
    if (!this.account.trim()) {
      promptAction.showToast({
        message: '请输入账号',
        duration: 2000
      });
      return false;
    }

    if (!this.name.trim()) {
      promptAction.showToast({
        message: '请输入姓名',
        duration: 2000
      });
      return false;
    }

    if (!this.isTeacher) {
      if (this.score < 0 || this.score > 4.0) {
        promptAction.showToast({
          message: '请输入有效的绩点(0-4.0)',
          duration: 2000
        });
        return false;
      }

      if (this.cet[0] < -1 || this.cet[0] > 710) {
        promptAction.showToast({
          message: '请输入有效的四级成绩(0-710)',
          duration: 2000
        });
        return false;
      }

      if (this.cet[1] < -1 || this.cet[1] > 710) {
        promptAction.showToast({
          message: '请输入有效的六级成绩(0-710)',
          duration: 2000
        });
        return false;
      }
    }

    return true;
  }


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
          Button('教师')
            .fontSize(16)
            .backgroundColor(this.isTeacher == true ? '#C5F4F3' : '#E5E5E5')
            .fontColor('#000000')
            .width(80)
            .onClick(() => {
              this.isTeacher = true;
            });
          Button('学生')
            .fontSize(16)
            .backgroundColor(this.isTeacher == false ? '#C5F4F3' : '#E5E5E5')
            .fontColor('#000000')
            .width(80)
            .onClick(() => {
              this.isTeacher = false;
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

        Text('姓名：')
          .fontSize(16)
          .width('96%')
          .margin({ top: 16});
        TextInput({ placeholder: '请输入他/她的姓名' })
          .width('90%')
          .height(40)
          .margin({ left: 16, right: 16, top: 4 })
          .onChange((value: string) => {
            this.name = value;
          });

        if (!this.isTeacher) {
          Text('专业：')
            .width('96%')
            .fontSize(16)
            .margin({ top: 16});
          Row() {
            // 计科专业选择
            Text('计科')
              .fontSize(18)
              .backgroundColor(this.major == 0 ? '#C5F4F3' : '#E5E5E5')  // 选中时为蓝色  // 未选择学生时不可用
              .borderRadius(12)
              .padding({
                left: 12,
                right: 12,
                bottom: 5,
                top: 5
              })
              .margin({ left: 10, right: 10 })
              .onClick(() => {
                this.major = 0
              });

            // 软工专业选择
            Text('软工')
              .backgroundColor(this.major == 1 ? '#C5F4F3' : '#E5E5E5')  // 未选择学生时不可用
              .borderRadius(12)
              .fontSize(18)
              .padding({
                left: 12,
                right: 12,
                bottom: 5,
                top: 5
              })
              .margin({ left: 10, right: 10 })
              .onClick(() => {
                this.major = 1
              });

            Text('智能')
              .fontSize(18)
              .padding({
                left: 12,
                right: 12,
                bottom: 5,
                top: 5
              })
              .backgroundColor(this.major == 2 ? '#C5F4F3' : '#E5E5E5')  // 未选择学生时不可用
              .borderRadius(12)
              .margin({ left: 10, right: 10 })
              .onClick(() => {
                this.major=2
              });

            // 网安专业选择
            Text('网安')
              .margin({ left: 10, right: 10 })
              .padding({
                left: 12,
                right: 12,
                bottom: 5,
                top: 5
              })
              .backgroundColor(this.major == 3 ? '#C5F4F3' : '#E5E5E5')  // 未选择学生时不可用
              .borderRadius(12)
              .fontSize(18)
              .onClick(() => {
                this.major=3
              });
          }
          .width('100%')
          Row() {
            Text('绩点/4.0：')
              .fontSize(16)
            TextInput()
              .width('25%')
              .onChange((value: string) => {
                this.score = Number(value);
              })
              .margin({ right: 16 });
          }.width('96%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 16 });

          Row() {
            Text('四级：')
              .fontSize(16)
            TextInput({ placeholder: '0表示未考' })
              .width('40%')
              .margin({ right: 16 })
              .onChange((value: string) => {
                this.cet[0] = Number(value);
              })
              .type(InputType.Number);

            }.width('96%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .margin({ top: 16 });
          Row() {
            Text('六级：')
              .fontSize(16)
            TextInput({ placeholder: '0表示未考' })
              .width('40%')
              .margin({ right: 16 })
              .onChange((value: string) => {
                this.cet[1] = Number(value);
              })
              .type(InputType.Number);
          }.width('96%')
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)
          .margin({ top: 16 });
        }

        Text(`生成密码为：123456`)
          .fontSize(16)
          .width('96%')
          .margin({ top: 32 });
/*
        Row() {
          Text('数据导出权限')
            .fontSize(16)
            .margin({ top: 16,bottom:10 });
          Toggle({ type: ToggleType.Switch, isOn: this.dataExportPermission })
            .margin({right: 16 })
            .onChange((isOn: boolean) => {
              this.dataExportPermission = isOn;
            });
        }
        .width('96%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
*/
        Button('确定')
          .width(120)
          .height(40)
          .backgroundColor('#87E8DE')
          .borderRadius(20)
          .margin({ top: 24, bottom: 32 })
          .onClick(async () => {
            if (await this.submitAccountInfo()) {
              router.back()
            }
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