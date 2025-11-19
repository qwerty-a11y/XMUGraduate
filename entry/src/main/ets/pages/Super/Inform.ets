import router from '@ohos.router';
import { Account, Student, Teacher } from '../../datatypes/Account';
import { AccountList } from '../../service/Super/AccountList';
import http from '@ohos.net.http';
import { DynamicData, StaticData } from '../../constants';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { AWARD_LEVELS_ARRAY } from '../../datatypes/TypeInfoEnums';

interface AccountData{
  ID: string;
  Name: string;
  Score?: number; // 可选字段
}
// 定义返回数据的接口
interface AccountResponse {
  AccountList: Array<AccountData>;
}

@Entry
@Component
export struct SuperInform {
  // 图标资源
  @Prop image_back: ResourceStr = $r('app.media.LeftArrow');
  @Prop image_check: ResourceStr = $r('app.media.check');

  // 学生数据 - 初始化为全部选中
  @State AccountData: Account[] = [
    new Student("xxxxxxxxxxxxxxx","XXX",3.0),
    new Student("xxxxxxxxxxxxxxx","XXX",3.0),
    new Student("xxxxxxxxxxxxxxx","XXX",3.0),
    new Student("xxxxxxxxxxxxxxx","XXX",3.0),
    //new Teacher("XXX","xxxxxxxxxxxxxxx")
  ];

  @State AccountSelect: boolean[]=[]

  // 状态管理
  @State currentPage: number = 1;
  private totalPages: number = 6;
  @State batchOperationMode: boolean = false; // 批量操作模式开关
  @State allSelected: boolean = true; // 全选状态

  @State ListType:number=AccountList.Type

  // 解析函数 - 根据账户类型解析数据
  parseAccountData(data: AccountResponse, accountType: boolean): Account[] {
    const accounts: Account[] = [];

    for (const item of data.AccountList) {
      if (accountType === false) {
        // 学生类型需要Score，如果不存在则使用默认值0
        const score = item.Score != undefined ? item.Score : 0;
        accounts.push(new Student(item.ID, item.Name, score));
      } else {
        // 教师类型不需要Score
        accounts.push(new Teacher(item.ID, item.Name));
      }
    }

    return accounts;
  }

  // 请求函数
  async getAccountList(
  accountType: boolean,
  majorParam: number
) {
  const httpRequest = http.createHttp();

  try {
    // 构建查询参数
    const params = `?type=${accountType}&major=${majorParam}`;

    const response: http.HttpResponse = await httpRequest.request(
      `${StaticData.ServerURL}/api/account/query${params}`, // 请替换为实际API路径
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
      try {
        const dataObj: AccountResponse = JSON.parse(response.result.toString());

        // 解析数据并存入数组
        this.AccountData = this.parseAccountData(dataObj, accountType);
        this.AccountSelect = new Array(this.AccountData.length).fill(true)

      } catch (parseError) {
        const error = parseError as BusinessError;
        promptAction.showToast({
          message: `数据解析错误: ${error.message}`,
          duration: 2000
        });
      }
    } else {
      promptAction.showToast({
        message: `请求失败，状态码: ${response.responseCode}`,
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


  aboutToAppear(): void {
    this.getAccountList(AccountList.Type<2,AccountList.Major())
  }

  // 全选方法 - 强制所有项选中
  selectAll() {
    this.AccountSelect.forEach((_, index) => {
      this.AccountSelect[index] = true;
    });
    this.allSelected = true;
  }

  // 取消全选方法 - 强制所有项未选中
  deselectAll() {
    this.AccountSelect.forEach((_, index) => {
      this.AccountSelect[index] = false;
    });
    this.allSelected = false;
  }

  // 检查是否所有项都被选中
  checkAllSelected(): boolean {
    return this.AccountSelect.every(item => item);
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 8 })
          .onClick(() => {
            router.back()
          });

        Text('信息与操作')
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .fontSize(14)
          .fontWeight(FontWeight.Medium);

        Column() {}
        .width(24)
        .height(24)
        .margin({ right: 8 });
      }
      .width('100%')
      .height('10%')
      .position({ top: 0 })
      .backgroundColor('#ffffff')
      .alignItems(VerticalAlign.Center)
      .shadow({ radius: 2, color: '#00000010' });

      Column() {
        // 批量操作与全选控制区
        Row() {
          Text('批量操作')
            .fontSize(14)
            .backgroundColor(this.batchOperationMode ? '#C5F4F3' : '#E5E5E5')
            .borderRadius(12)
            .padding({ left: 8, right: 8, bottom: 4, top: 4 })
            .margin({ right: 25, left: 5 })
            .onClick(() => {
              this.batchOperationMode = !this.batchOperationMode;
              // 进入批量操作模式时默认全选
              if (this.batchOperationMode) {
                this.selectAll();
              }
            });

          if (this.batchOperationMode) {
            Text('全选')
              .fontSize(14);

            Toggle({ type: ToggleType.Switch, isOn: this.allSelected })
              .margin({ left: 5 })
              .onChange((isOn: boolean) => {
                isOn ? this.selectAll() : this.deselectAll();
              });

            Image($r('app.media.check'))
              .width(24)
              .height(24)
              .margin({ left: 50, right: 8 })
              .onClick(() => {
                router.pushUrl({ url: 'pages/Super/Operate'});
              });
          }
        }
        .width(300)
        .margin({ top: 10, bottom: 10, left: 10 });

        // 学生列表
        List() {
          ForEach(this.AccountData, (item: Student|Teacher, index: number) => {
            ListItem() {
              Row(){
                // 仅在批量操作模式下显示勾选框
                if (this.batchOperationMode) {
                  Toggle({
                    type: ToggleType.Checkbox,
                    isOn: this.AccountSelect[index]  // 勾选状态与数据绑定
                  })
                    .width('5%')
                    //.height(40)
                    .onChange((isOn: boolean) => {
                      // 更新数据状态
                      this.AccountSelect[index] = isOn;
                      // 同步更新全选开关状态
                      this.allSelected = this.checkAllSelected();
                    });
                }
                Row() {

                  if (this.ListType==0) {
                    // 排名
                    Text("No." + (index+1).toString())
                      .fontSize(14)
                      .textAlign(TextAlign.Center);
                  }

                  // 姓名
                  Text(item.Name)
                    .fontSize(14)
                    .textAlign(TextAlign.Center);

                  // 学号/工号
                  Text(item.ID)
                    .fontSize(14)
                    .textAlign(TextAlign.Center);
                  if (this.ListType<2) {
                    // 分数
                    Text((item as Student).Score?.toString()+"分")
                      .fontSize(14)
                      .textAlign(TextAlign.Center);
                  }
                }
                .width(this.batchOperationMode?'92%':'100%')
                .flexGrow(1)
                .backgroundColor('#ffffff')
                .padding({ left: 16, right: 16, bottom: 6, top: 6 })
                //.margin({ top: 5, bottom: 5 })
                .height(40)
                .borderRadius(8)
                .shadow({ radius: 1, color: '#00000008' })
                .justifyContent(FlexAlign.SpaceBetween)
                .onClick(() => {
                  router.pushUrl({ url: 'pages/Super/Individual' ,params:item});
                });
              }
              .margin({ top: 5, bottom: 5 })
              .padding({ top:0,bottom:0 })
              .height(40)


            }.padding(0)
          });
        }
        .width('90%')
        .height('90%');
      }
      .height('90%')
      .width('100%')
      .position({ y: '10%' });
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F5F5F5');
  }
}
