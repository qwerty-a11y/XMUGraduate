import { Poster } from '../Stu/HomeComponents/TypeCard';
import {Request} from  '../../../datatypes/PasswordResetRequest'
import {DateUtils} from '../../../utils'
import router from '@ohos.router'; // 导入路由模块
import { http } from '@kit.NetworkKit';
import { DynamicData, StaticData } from '../../../constants';
import { StudentDetail, TeacherDetail } from '../../../datatypes/AccountDetail';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';


@Component
export struct superHomeView {
  @State homeNavBgColor: string = '#ffffffff';
  @Prop image_inform: ResourceStr = $r("app.media.inform");
  @Prop image_set: ResourceStr = $r("app.media.Settings");
  @Prop image_search: ResourceStr = $r("app.media.Search");
  @State SearchText: string = '';

  // 网络请求函数
  async getAccountDetail(
    id: string
  ) {
    const httpRequest = http.createHttp();

    try {
      // 构建查询参数
      const params = `?type=0&id=${encodeURIComponent(id)}`;

      const response: http.HttpResponse = await httpRequest.request(
        `${StaticData.ServerURL}/api/account/admin/retrieve/${params}`, // 请替换为实际API路径
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': `Token ${DynamicData.token}`
          },
          connectTimeout: 5000
        }
      );

      if (response.responseCode === 200) {
        router.pushUrl({ url: 'pages/Super/Individual' ,params: {
          ID:id
        }});
      } else {
        promptAction.showToast({
          message: `无法获取账户信息，请检查学号是否正确`,
          duration: 2000
        });
      }
    } catch (requestError) {
      const error = requestError as BusinessError;
      console.log(`请求错误: ${error.message}`);
      promptAction.showToast({
        message: '网络请求失败，请检查网络连接',
        duration: 2000
      });
    }
  }

  @State cardData: Array<Request> = [];
  @Builder
  CardComponent(item: Request) {
    Row() {
      Column() {
        Row() {
          Text('待处理')
            .fontSize(14)
            .margin({ right: 5 });
          // 状态圆点
          Circle()
            .width(8)
            .height(8)
            .fill(Color.Red);
        }
        .margin({ bottom: 5 });

        Text(`来自：${item.Name} ${item.Identity?'老师':'学生'}`)
          .fontSize(16);
      }
      .width('50%')
      .margin({ bottom: 10, top: 10 });

      Column() {
        Text(DateUtils.ToString(item.UploadTime))
          .fontSize(12)
          .fontColor('#999999');
      }
      .width('50%')
      .alignItems(HorizontalAlign.Center)
      .margin({ right: 10 });
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .shadow({
      radius: 4,
      color: '#DDDDDD',
      offsetX: 0,
      offsetY: 2
    })
    .width(340)
    .onClick(()=>{
      router.pushUrl({url:'pages/Super/StudentAccountIssue',params:item})
    })
    .justifyContent(FlexAlign.Center); // 卡片内容水平居中
  }

  build() {
    Column() {
      // 顶部搜索及设置区域
      Row() {
        Row() {
          Image(this.image_search)
            .width(24)
            .height(24)
            .margin({ left: 12 })
          TextInput({
            placeholder: '输入学号查询学生信息',
            text: this.SearchText
          })
            .fontSize(16)
            .height(32)
            .backgroundColor('white')
            .placeholderColor('#999999')
            .margin({ left: 8 })
            .layoutWeight(1)
            .onChange((text)=>{
              this.SearchText=text
            })
            .onSubmit(()=>{
              this.getAccountDetail(this.SearchText)
            })
        }
        .backgroundColor('white')
        .borderRadius(20)
        .height(52)
        .width(270)
        .shadow({
          radius: 4,
          color: '#10000000',
          offsetX: 0,
          offsetY: 2
        })
        .margin({ left: 15 });

        Image(this.image_set)
          .width(24)
          .height(24)
          .margin({ left: 8, right: 5 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Super/Setting' });
          });

        Image(this.image_inform)
          .width(24)
          .height(24)
          .onClick(() => {
            router.pushUrl({ url: 'pages/Super/Feedback' });
          });
      }
      .width('100%')
      .height('10%')
      .backgroundColor('#fff4fafa')
      .shadow({ radius: 10, color: '#00000010' })
      .alignItems(VerticalAlign.Center);

      // 可滚动内容区域
      Scroll() {
        Column() {
          Text('Hi~')
            .fontSize(30)
            .width(320)
            .margin({ top: 10, bottom: 5 });

          Poster()
            .width(343)
            .height(192)
            .margin({ bottom: 10 });

          Column(){
            Text('新添')
              .width('100%')
              .fontSize(14)
              .margin({bottom:5})

            Column(){
              Text('新添学生/教师')
            }
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height(42)
            .backgroundColor('#84F2C3')
            .borderRadius(20)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Super/Add' });
            });
          }
          .width(330)
          .margin({bottom:15})

          Column() {
            Text('批量新添')
              .width('100%')
              .fontSize(14)
              .margin({ bottom: 5 })

            Row() {
              Column() {
                Text('新添学生')
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .width('48%')
              .height(42)
              .backgroundColor('#AAFAFB')
              .borderRadius(20)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Super/AddStudent' });
              });

              Column() {
                Text('新添教师')
              }
              .alignItems(HorizontalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .width('48%')
              .height(42)
              .backgroundColor('#AAFAFB')
              .borderRadius(20)
              .onClick(() => {
                router.pushUrl({ url: 'pages/Super/AddTeacher' });
              });
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width(330)
          .margin({bottom:15})

          Column(){
            Column() {
              Text('账号问题')
                .fontSize(14)
                .width('100%')
            }
            .width(330)

            Column(){
              if (this.cardData.length == 0){
                Text("暂无账号问题反馈").margin({top:40}).fontColor(Color.Gray)
              } else {
                List() {
                  ForEach(this.cardData, (item: Request) => {
                    ListItem() {
                      this.CardComponent(item);
                    }
                    .margin({ bottom: 5, top: 5 })
                    .width(340)
                  });
                }
                .width(330)
              }
            }
            .backgroundColor('#ffffff')
            .width(340)
            .constraintSize({minHeight:100})

          }
          // 增加一个大的底部边距，确保Scroll内容高度超过自身高度，可滑动
          .margin({ bottom: 100 })
        }
        .width('100%')
        .constraintSize({
          minHeight:'100%'
        })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)
      }
      .height('90%') // 设置Scroll高度为屏幕的90%，确保有足够空间容纳内容并可滑动
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f4fafa');
  }
}

