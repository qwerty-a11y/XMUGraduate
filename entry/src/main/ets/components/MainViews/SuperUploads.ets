import router from '@ohos.router';

interface MajorState {
  计科: boolean;
  软工: boolean;
  智能: boolean;
  网安: boolean;
}

// 定义整体选择状态接口
interface SelectState {
  teacherSelected: boolean;
  studentSelected: boolean;
  majors: MajorState;
}

@Component
export struct superUploadsView {
  @State selectState: SelectState = {
    teacherSelected: false,
    studentSelected: false,
    majors: {
      计科: false,
      软工: false,
      智能: false,
      网安: false
    }
  };

  // 重置所有专业选择状态
  resetMajors() {
    this.selectState.majors.计科 = false;
    this.selectState.majors.软工 = false;
    this.selectState.majors.智能 = false;
    this.selectState.majors.网安 = false;
  }

  build() {
    Column() {
      // 选择所有账号操作按钮
      Button('选择所有账号操作')
        .width('80%')
        .height(50)
        .backgroundColor('#84F2C3')
        .fontColor('#000000')
        .borderRadius(20)
        .margin({ top: 20, bottom: 20 })
        .shadow({
          radius: 4,
          color: '#ff5a5555',
          offsetX: 2,
          offsetY: 4
        });

      Column() {
        Column() {
          Text('自定义操作')
            .fontSize(18)
            .width('100%')

          Column() {
            // 顶部提示文本
            Text('请选择您要查询或批量操作的对象属性，可多选,不能同时选择教师和学生')
              .fontSize(18)
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 20, bottom: 20, left: 20, right: 20 });
          }
          .backgroundColor('#C5F4F3')
          .margin({ top: 10, bottom: 20 });
        }
        .width('100%')

        Column() {
          // 身份选择-教师
          Row() {
            Text('身份')
              .fontSize(18)
              .margin({ left: 30, top: 20, bottom: 20 })
              .width('30%');

            Text('教师')
              .backgroundColor(this.selectState.teacherSelected ? '#C5F4F3' : '#E5E5E5')
              .borderRadius(12)
              .fontSize(18)
              .padding({ left: 12, right: 12, bottom: 5, top: 5 })
              .onClick(() => {
                // 切换教师选择状态
                this.selectState.teacherSelected = !this.selectState.teacherSelected;

                // 选择教师时，自动取消学生和所有专业选择
                if (this.selectState.teacherSelected) {
                  this.selectState.studentSelected = false;
                  this.resetMajors();
                }
              });
          }
          .width('100%')
          .backgroundColor('#ffffff')
          .borderRadius(20)
          .shadow({
            radius: 4,
            color: '#ff5a5555',
            offsetX: 2,
            offsetY: 4
          })
          .margin({ bottom: 20 });

          // 身份选择-学生及专业
          Column() {
            Row() {
              Text('身份')
                .fontSize(18)
                .margin({ left: 30, top: 20, bottom: 20 })
                .width('30%');

              Text('学生')
                .fontSize(18)
                .padding({ left: 12, right: 12, bottom: 5, top: 5 })
                .backgroundColor(this.selectState.studentSelected ? '#C5F4F3' : '#E5E5E5')
                .borderRadius(12)
                .onClick(() => {
                  // 切换学生选择状态
                  this.selectState.studentSelected = !this.selectState.studentSelected;

                  // 选择学生时，自动取消教师选择
                  if (this.selectState.studentSelected) {
                    this.selectState.teacherSelected = false;
                  } else {
                    // 取消学生选择时，自动取消所有专业选择
                    this.resetMajors();
                  }
                });
            }
            .width('100%')
            .margin({ bottom: 10 });

            Column() {
              Text('专业')
                .fontSize(18)
                .margin({ left: 50, top: 20, bottom: 20 })
                .width('100%');

              Column() {
                Row() {
                  // 计科专业选择
                  Text('计科')
                    .fontSize(18)
                    .backgroundColor(this.selectState.studentSelected
                      ? (this.selectState.majors.计科 ? '#4096ff' : '#E5E5E5')  // 选中时为蓝色
                      : '#E5E5E5')  // 未选择学生时不可用
                    .borderRadius(12)
                    .padding({ left: 12, right: 12, bottom: 5, top: 5 })
                    .margin({ left: 10, right: 10 })
                    .onClick(() => {
                      // 只有选择学生时才允许切换专业状态
                      if (this.selectState.studentSelected) {
                        if(this.selectState.majors.计科) this.selectState.majors.计科 = false;
                        else if(!this.selectState.majors.计科) this.selectState.majors.计科 = true;
                      }
                    });

                  // 软工专业选择
                  Text('软工')
                    .backgroundColor(this.selectState.studentSelected
                      ? (this.selectState.majors.软工 ? '#4096ff' : '#E5E5E5')  // 选中时为蓝色
                      : '#E5E5E5')  // 未选择学生时不可用
                    .borderRadius(12)
                    .fontSize(18)
                    .padding({ left: 12, right: 12, bottom: 5, top: 5 })
                    .margin({ left: 10, right: 10 })
                    .onClick(() => {
                      if (this.selectState.studentSelected) {
                        this.selectState.majors.软工 = !this.selectState.majors.软工;
                      }
                    });
                }
                .width('70%')
                .margin({ bottom: 20 })
                .justifyContent(FlexAlign.SpaceBetween);

                Row() {
                  // 智能专业选择
                  Text('智能')
                    .fontSize(18)
                    .padding({ left: 12, right: 12, bottom: 5, top: 5 })
                    .backgroundColor(this.selectState.studentSelected
                      ? (this.selectState.majors.智能 ? '#4096ff' : '#E5E5E5')  // 选中时为蓝色
                      : '#E5E5E5')  // 未选择学生时不可用
                    .borderRadius(12)
                    .margin({ left: 10, right: 10 })
                    .onClick(() => {
                      if (this.selectState.studentSelected) {
                        this.selectState.majors.智能 = !this.selectState.majors.智能;
                      }
                    });

                  // 网安专业选择
                  Text('网安')
                    .margin({ left: 10, right: 10 })
                    .padding({ left: 12, right: 12, bottom: 5, top: 5 })
                    .backgroundColor(this.selectState.studentSelected
                      ? (this.selectState.majors.网安 ? '#4096ff' : '#E5E5E5')  // 选中时为蓝色
                      : '#E5E5E5')  // 未选择学生时不可用
                    .borderRadius(12)
                    .fontSize(18)
                    .onClick(() => {
                      if (this.selectState.studentSelected) {
                        this.selectState.majors.网安 = !this.selectState.majors.网安;
                      }
                    });
                }
                .width('70%')
                .justifyContent(FlexAlign.SpaceBetween)
                .margin({ bottom: 20 })
              }
              .width('100%');
            }
            .width('100%');
          }
          .width('100%')
          .shadow({
            radius: 4,
            color: '#ff5a5555',
            offsetX: 2,
            offsetY: 4
          })
          .margin({ bottom: 20 })
          .backgroundColor('#ffffff')
          .borderRadius(20);
        }
        .width('100%')


        // 确定按钮
        Button('确定')
          .width(120)
          .height(52)
          .fontColor('#000000')
          .backgroundColor('#84F2C3')
          .borderRadius(20)
          .onClick(() => {
            console.log('选择的状态：', this.selectState);
            router.pushUrl({ url: 'pages/Superinform' });
          });
      }
      .width('85%')

    }
    .width('100%')
    .height('90%')
    .backgroundColor('#F5F5F5')
    .alignItems(HorizontalAlign.Center);
  }
}
