import router from '@ohos.router';

@Entry
@Component
struct PushScoreRulesPage {
  @Prop image_back: ResourceStr = $r("app.media.LeftArrow");
  build() {
    Column() {
      Row() {
        // 返回图标
        Image(this.image_back)
          .width(24)
          .height(24)
          .margin({ left: 8 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Tea/Main' });
          });

        // 页面标题
        Text('保研条例')
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .fontSize(14)
          .fontWeight(FontWeight.Medium);

        // 右侧占位元素，保持标题居中
        Column() {}
        .width(24)
        .height(24)
        .margin({ right: 8 });
      }
      .width('100%')
      .height(30)
      .backgroundColor('#ff8ee7e7')
      .alignItems(VerticalAlign.Center)
      .shadow({ radius: 2, color: '#00000010' });
      Scroll() {
        Column({ space: 16 }) {
          // 页面标题
          Text("推免考核综合成绩加分细则")
            .fontSize(20)
            .fontWeight(500)
            .fontColor('#333333')
            .width('100%')
            .textAlign(1)
            .margin({ top: 20, bottom: 15 });

          // 核心说明
          Text("由学院推免工作小组工作人员按照以下加分细则，根据申请学生提交的有效证明材料予以审核计算。考核综合成绩分为学术专长成绩（该项满分为15分，超过15分以15分计）和综合表现成绩（该项满分为5分，超过5分以5分计）两类。")
            .fontSize(16)
            .fontColor('#333333')
            .width('100%')
            .textAlign(0)
            .padding({ left: 16, right: 16 });

          // 一、学术专长成绩
          Text("（一）学术专长成绩")
            .fontSize(18)
            .fontWeight(500)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 12, left: 16 });

          Text("学术专长成绩综合考察学生本科学习期间，在科研成果、学业竞赛等学术专长方面的综合得分情况。")
            .fontSize(16)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 16, right: 16, top: 4 });

          // 1. 科研成果
          Text("1. 科研成果")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });

          // （1）学术论文
          Text("（1）学术论文")
            .fontSize(16)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 6, left: 30 });

          Text("在《厦门大学信息学院（特色化示范性软件学院）本科生推荐学术会议和期刊目录》（见附件1）指定的期刊或会议上发表并收录的非综述、非快报类长文或正文，A类每篇加10分，B类每篇加6分，C类每篇加1分且C类累计不超过2篇。厦门大学必须是第一单位。除导师外的作者，只加前2名，除导师外，排序第一的加80%，排序第二的加20%，共同第一作者，排序第一和第二的各加50%；除导师外，本科生是独立作者的，加100%。每篇论文只认1名导师。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });

          Text("《厦门大学信息学院（特色化示范性软件学院）本科生推荐学术会议和期刊目录》中，Nature，Science，Cell主刊及其刊物名为Nature *，Science*，CELL*的子刊长文及正文，CELL旗下刊物要求影响因子IF≥10以上，等价于两篇A类，即每篇加20分；高水平中文学术期刊等价于B类；信息与通信工程学科推荐国际学术期刊等价于A类。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 4 });

          // （2）国家发明专利
          Text("（2）国家发明专利")
            .fontSize(16)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 6, left: 30 });

          Text("获得国家发明专利授权者，每项加2分。专利授权以证书上的时间为准。厦门大学必须是第一单位，专利只认除导师外的第一作者，加80%，本科生是独立作者的，加100%。每个专利只认1名导师。授权以证书上的时间为准。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });

          // 2. 学业竞赛
          Text("2. 学业竞赛")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });

          Text("以厦门大学为单位，在《厦门大学信息学院（特色化示范性软件学院）本科生学业竞赛项目库》（见附件2）指定的竞赛中获奖的：")
            .fontSize(16)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 16, right: 16, top: 2 });

          // 学业竞赛表格（无循环，逐行写）
          Column({ space: 2 }) {
            // 表头
            Row() {
              Text("级别")
                .fontSize(14)
                .fontWeight(500)
                .width('20%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
              Text("奖项")
                .fontSize(14)
                .fontWeight(500)
                .width('20%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
              Text("A+类")
                .fontSize(14)
                .fontWeight(500)
                .width('20%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
              Text("A类")
                .fontSize(14)
                .fontWeight(500)
                .width('20%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
              Text("A-类")
                .fontSize(14)
                .fontWeight(500)
                .width('20%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行1
            Row() {
              Text("国家级")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("一等奖及以上")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("30")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("15")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("10")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行2
            Row() {
              Text("国家级")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("二等奖")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("15")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("10")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("5")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行3
            Row() {
              Text("国家级")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("三等奖")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("10")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("5")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("2")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行4
            Row() {
              Text("省级")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("一等奖及以上")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("5")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("2")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("1")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行5
            Row() {
              Text("省级")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("二等奖")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("2")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("1")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.5")
                .fontSize(14)
                .width('20%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');
          }
          .width('90%')
          .margin({ left: 20, top: 8, bottom: 8 });

          // 学业竞赛说明“
          Text("说明：")
            .fontSize(16)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 6, left: 30 });

          Text("(1)学业竞赛加分项目，每个学生不超过3项。非信息学院项目，每个学生加分不超过1项。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });

          Text("(2)在ICPC亚洲区域赛、CCPC竞赛中获奖的，按照A类竞赛标准加分。进入ICPC全球总决赛的，按照A+类竞赛标准加分。同一年度的ICPC和CCPC只加最高分，不累计加分，邀请赛不加分。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });

          Text("(3)全国CCF计算机软件能力认证（简称CCF CSP认证）考试按照A-类竞赛的标准加分，排名前0.2%，等同全国一等奖；排名前1.5%，等同全国二等奖；排名前3%，等同全国三等奖，此认证只加最高分，不累计加分。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });

          Text("(4) 团体项目获奖的，中国国际大学生创新大赛、“挑战杯” 全国大学生课外学术科技作品竞赛、“挑战杯” 中国大学生创业计划大赛的队长，按同一级别团体项目获奖加分值的 1/3 计算，排序第 2-3 的队员，按同一级别团体项目获奖加分值的 1/4 计算，排序 4-5 名的队员，按同一级别团体项目获奖加分值的 1/5 计算。其他竞赛，不考虑参赛成员身份，团队成员为 2 人的，参赛成员不考虑排名先后，各按同一级别团体项目获奖加分值的 1/3 计算；团队成员为 3-5 人的，参赛成员不考虑排名先后，按参赛人数平均计算加分值。团队成员超过 5 人的，每项成果只取前 5 名核心成员计算，5 名核心成员不考虑排名先后，按 5 人平均计算加分值。个人项目获奖加分按同一级别团体项目获奖加分值的 1/3 计算。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });
          Text("(5) 属于同一件参赛作品，参加多项不同的竞赛并获奖，只按照获奖最高级别或最高分值加分，不得累计加分。作品类竞赛，学生在省赛、国赛不同阶段参赛时，需提前将竞赛名称、作品名称、作品简介、指导老师、队长和团队成员信息上传到学院指定平台备案。属于同一研究方向作品迭代升级参赛的，需在作品简介中说明迭代升级情况，并由学院审定是否属于同一作品；同一竞赛年度，属于同一项赛事不同级别、不同组别、不同赛道或者不同站点的，只按照获奖最高级别或最高分值加分，不得累计加分。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });
          Text("(6) 同一赛事的次级比赛加分按照同级同类计算，如国家级 A 类竞赛的省级获奖按照省级 A 类计分。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });
          Text("(7) 不在《厦门大学信息学院（特色化示范性软件学院）本科生学业竞赛项目库》的竞赛项目，不予认定加分。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });
          Text("(8) 以上获奖以主办方提供的证明为准。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });
          // 3. 创新创业训练
          Text("3. 创新创业训练")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });
          Text("参加创新实验计划项目者，必须项目结题方可加分（需教务处开具证明或者创新网已结题截图，以结项时间为准）。国家级立项，组长加 1 分，成员加 0.3 分；省级立项，组长加 0.5 分，成员加 0.2 分；校级立项，组长加 0.1 分，成员加 0.05 分。同一项目获得多级别立项，只按照最高分值加分，不得累计加分。该项最多加 2 分。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 30, right: 16, top: 2 });
          // 二、综合表现加分
          Text("（二）综合表现加分")
            .fontSize(18)
            .fontWeight(500)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 12, left: 16 });
          Text("综合表现加分是考察学生本科学习期间，在国际组织实习、参军入伍服兵役、参加志愿服务、社会工作、体育比赛，获得荣誉称号等情况的加分。")
            .fontSize(16)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 16, right: 16, top: 4 });
          // 1. 国际组织实习
          Text("1. 国际组织实习")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });
          Text("到国际组织实习，满一学年的得 1 分，超过一个学期但不满一年的按一学年标准减半计算，不满一个学期的不加分。该项最多加 1 分。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 30, right: 16, top: 2 });
          // 2. 参军入伍服兵役
          Text("2. 参军入伍服兵役")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });
          Text("在校期间参军入伍服兵役的学生，一年以上（含一年）、两年以内的，加 1 分；两年以上（含两年）的加 2 分。该项最多加 2 分。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 30, right: 16, top: 2 });
          // 3. 志愿服务
          Text("3. 志愿服务")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });
          Text("参加支教开发、社区建设、环境保护、校园公益、应急救助等志愿服务工作：")
            .fontSize(16)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 30, right: 16, top: 2 });
          Text("（1）志愿服务时间")
            .fontSize(16)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 6, left: 40 });
          Text("累计登记的志愿服务时间达到 200 小时以上（含 200 小时），并得到志愿服务对象认可。志愿服务时间达到 200 小时后，每增加 2 小时可增加 0.05 分。大型赛会志愿者（98 国际投资贸易洽谈会、厦门对台进出口商品交易会等）与支教活动工时减半。该项最多加 1 分。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 50, right: 16, top: 2 });
          Text("（2）志愿服务表彰")
            .fontSize(16)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 6, left: 40 });
          Text("个人或团队参加过重大活动的志愿服务工作并获得服务单位或组织单位的表彰的，或在志愿服务方面有其他（抢险救灾、见义勇为、舍己为人等方面）突出表现或产生较大社会影响者，按以下标准加分：")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 50, right: 16, top: 2 });
          // 志愿服务表彰表格（无循环，逐行写）
          Column({ space: 2 }) { // 表头
            Row() {
              Text("志愿服务表彰")
                .fontSize(14)
                .fontWeight(500)
                .width('25%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
              Text("团队队长")
                .fontSize(14)
                .fontWeight(500)
                .width('25%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
              Text("团队队员")
                .fontSize(14)
                .fontWeight(500)
                .width('25%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 })
              ;
              Text("个人")
                .fontSize(14)
                .fontWeight(500)
                .width('25%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行 1
            Row() {
              Text("国家级")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("1")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 })
              ;
              Text("0.5")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("1")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行 2
            Row() {
              Text("省级")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.5")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.25")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.5")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行 3
            Row() {
              Text("校级")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 })
              ;
              Text("0.25")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.1")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.25")
                .fontSize(14)
                .width('25%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');
          }
          .width('90%')
          .margin({ left: 20, top: 8, bottom: 8 });

          Text("参加志愿服务活动的工时认定以厦门大学志愿者管理系统中的工时报表为准，工时认定的时间以录入系统并审核通过的时间为准。因同一志愿服务工作或表现同时获得多个表彰，只按照最高分值加分，不得累计加分。若个人和团队同时获得表彰的，只按照最高分值加分，不得累计加分。该项最多加 1 分。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 50, right: 16, top: 4 });
          // 4. 荣誉称号
          Text("4. 荣誉称号")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });
          Text("被评为国家级（以国务院、教育部、共青团中央公章为准）优秀三好学生、优秀共产党员、五四红旗团支部、优秀团员、“自强之星”、社会实践活动优秀团队或个人等荣誉称号，每项可加 2 分；被评为省级（以省政府、省教育厅、团省委等公章为准）优秀三好学生、优秀学生干部、优秀共产党员、五四红旗团支部、优秀团员、优秀团支部书记、社会实践活动优秀团队或个人等荣誉称号，每项可加 1 分；被评为校级优秀三好学生、三好学生、优秀学生干部、优秀共产党员、五四红旗团支部、优秀团员、优秀团支部书记、优秀院学生会主席、优秀班集体、优秀院学生会等荣誉称号，每项可加 0.2 分。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 30, right: 16, top: 2 });
          Text("上述表彰中，同一学年度获得多项荣誉称号的，只按照最高分值加分，不得累计加分。集体荣誉称号加分，所在集体每位成员均可得分，得分减半。该项最多加 2 分。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 30, right: 16, top: 4 });
          // 5. 社会工作
          Text("5. 社会工作")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });
          Text("担任学生干部根据担任职务的贡献大小按以下标准加分：")
            .fontSize(16)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 30, right: 16, top: 2 });
          // 社会工作加分表格（无循环，逐行写）
          Column({ space: 2 }) {
            // 表头
            Row() {
              Text("担任职务")
                .fontSize(14)
                .fontWeight(500)
                .width('40%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
              Text("系数")
                .fontSize(14)
                .fontWeight(500)
                .width('30%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
              Text("最终得分")
                .fontSize(14)
                .fontWeight(500)
                .width('30%')
                .textAlign(1)
                .backgroundColor('#f5f5f5')
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行 1
            Row() {
              Text("院学生会执行主席、团总支书记")
                .fontSize(14)
                .width('40%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("2")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("2 * 得分 / 100")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }.width('100%');

            // 行 2
            Row() {
              Text("院学生会主席团成员、团总支副书记")
                .fontSize(14)
                .width('40%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("1.5")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("1.5 * 得分 / 100")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行 3
            Row() {
              Text("院学生会、团总支各部部长，党支部书记，班长、团支部书记")
                .fontSize(14)
                .width('40%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("1")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("1 * 得分 / 100")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行 4
            Row() {
              Text("系团总支书记，院学生会、团总支各部门副部长，社团社长")
                .fontSize(14)
                .width('40%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.75")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.75 * 得分 / 100")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');

            // 行 5
            Row() {
              Text("党支部委员，系团总支各部部长，各班班委、团支部委员，院学生会、团总支长期志愿者，社团副社长及社团主要干部、辩论队队长、球队队长等")
                .fontSize(14)
                .width('40%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.5")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
              Text("0.5 * 得分 / 100")
                .fontSize(14)
                .width('30%')
                .textAlign(1)
                .border({ width: 1, color: '#eaeaea', style: 1 })
                .padding({ top: 6, bottom: 6 });
            }
            .width('100%');
          }
          .width('90%')
          .margin({ left: 20, top: 8, bottom: 8 });

          // 社会工作说明
          Text("说明：")
            .fontSize(16)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 6, left: 30 });
          Text("(1) 辅导员或指导老师针对学生任职学年的工作完成情况进行打分（0-100 分）。计算推免加分时，此项最终得分 = 系数 × 任职学年辅导员或指导老师打分 / 100。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });
          Text("(2) 校级学生组织各级别加分、计分参考上述标准（例如：校学生会主席加分值参照院学生会主席），校级学生组织指导老师对学生任职学年的工作完成情况进行打分（0-100 分），打分标准由学院向校级学生组织指导老师提供。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });
          Text("(3) 以上加分为任期满一学年的得分，超过一学期但不满一年的按一学年标准减半计算，不满一个学期的不加分。同一学年兼任多个学生干部职务的，只按照最高分值加分，不得累计加分。不同学年担任学生干部可累加。该项最多加 2 分。")
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 2 });
          // 6. 体育比赛
          Text("6. 体育比赛")
            .fontSize(17)
            .fontWeight(400)
            .fontColor('#333333')
            .width('100%')
            .margin({ top: 8, left: 16 });
          Text("代表厦门大学参加国家级及以上重大体育比赛并获奖的：")
            .fontSize(16)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 30, right: 16, top: 2 });
          Text("(1) 团体项目获得国际级冠军的，每项加 8 分；获得国际级亚军的，每项加 6.5 分；获得国际级季军或国家级冠军的，每项加 5 分；获得国家级亚军或国际级第四至八名的，每项 3.5 分；获得国家级季军的，每项加 2 分；获得国家级第四至八名的，每项加 1 分。以上获奖团体项目，参赛成员不考虑排名先后，按参赛人数平均计算加分值；二人项目或个人项目获奖，加分按同一级别团体项目获奖加分值的 1/3 计算。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({ left: 40, right: 16, top: 4 });
          Text("上述比赛获奖中，属于同一项赛事不同级别的比赛，只按照获奖最高级别或最高分值加分，不得累计加分。")
            .fontSize(15)
            .fontColor('#666666')
            .width('100%')
            .textAlign(0)
            .padding({
              left: 40,
              right: 16,
              top: 4,
              bottom: 30
            });
        } // 外层 Column 结束
      } // Scroll 结束
    }
    .width('100%')
    .height('100%')
  }//build 方法结束
}// 组件结束