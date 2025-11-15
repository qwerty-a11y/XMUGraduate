//-----学业竞赛-----

// 竞赛级别
export enum COMPETITION_LEVELS {
  A_PLUS = "A+级",
  A = "A级",
  A_MINUS = "A-级"
}

// 竞赛等级
export enum COMPETITION_GRADES {
  national = "国家级",
  provincial = "省级"
}

// 奖项等级
export enum AWARD_LEVELS {
  first = "一等奖",
  second = "二等奖",
  third = "三等奖"
}

//团队规模
export enum TEAM_NUMBER{
  under_5 = "5人以下",
  over_5 = "5人以上"
}

// 团队角色
export enum TEAM_ROLES {
  captain = "队长",
  member_2_3 = "2-3人队员",
  member_4_5 = "4-5人队员",
  individual = "个人"
}

// CCF认证排名
export enum CCF_RANKINGS {
  percent_0_2 = "前0.2%",
  percent_1_5 = "前1.5%",
  percent_3 = "前3%"
}

export enum CompetitionTypes{
  general = "竞赛",
  ccf = "CCF"
}

export interface Competition_general{
  competition_level: COMPETITION_LEVELS
  competition_grade: COMPETITION_GRADES
  award_level: AWARD_LEVELS
  team_number: TEAM_NUMBER
  team_role: TEAM_ROLES
}

export interface Competition_ccf{
  ccf_ranking: CCF_RANKINGS
}

//-----创新创业训练-----

// 创新训练级别
export enum INNOVATION_LEVELS {
  national = "国家级",
  provincial = "省级",
  university = "校级"
}

// 创新训练角色
export enum INNOVATION_ROLES {
  leader = "组长",
  member = "组员"
}

export interface Innovation{
  innovation_level: INNOVATION_LEVELS
  innovation_role: INNOVATION_ROLES
}

//-----科研成果-----

//论文类别
export enum PAPER_CATEGORIES{
  A = "A类论文",
  B = "B类论文",
  C = "C类论文"
}

//论文作者
export enum PAPER_AUTHORS{
  first_author = "第一作者",
  second_author = "第二作者",
  both_first = "共同一作",
  independent = "独立作者",
}

//专利作者类型
export enum PATENT_AUTHOR_TYPES {
  independent = "独立作者",
  first_author = "第一作者",
}

export enum ResearchTypes{
  paper = "论文",
  patent = "专利"
}

export interface Research_paper{
  paper_categorie: PAPER_CATEGORIES
  paper_author: PAPER_AUTHORS
}

export interface Research_patent{
  patent_author_type: PATENT_AUTHOR_TYPES
}

//-----荣誉称号-----

// 荣誉称号级别
export enum HONOR_TITLE_LEVELS {
  national = "国家级",
  provincial = "省级",
  university = "校级"
}

export interface Honor{
  honor_title_level: HONOR_TITLE_LEVELS
  score: number
}

//-----社会工作-----

export interface SocialWork{
  social_title: string
  score: number
}

//-----志愿服务-----

// 志愿服务表彰级别
export enum VOLUNTEER_AWARD_LEVELS {
  national = "国家级",
  provincial = "省级",
  university = "校级"
}

export enum VOLUNTEER_ROLE{
  leader = "队长",
  member = "成员",
  individual = "个人"
}

export enum VolunteerTypes{
  service = "志愿服务",
  award = "志愿表彰"
}

export interface Volunteer_service{
  volunteer_time: number[]
  score: number
}

export interface Volunteer_award{
  volunteer_award_level: VOLUNTEER_AWARD_LEVELS
  role: VOLUNTEER_ROLE
}

//-----国际组织学习-----

// 实习时长
export enum INTERNSHIP_DURATIONS {
  full_year = "一学年",
  less_than_year = "少于一学年"
}

export interface International{
  intership_duration: INTERNSHIP_DURATIONS
  score: number
}

//-----参军入伍-----

// 兵役时长
export enum MILITARY_SERVICE_DURATIONS {
  years_1_2 = "1-2年",
  over_2_years = "2年以上"
}

export interface Military{
  military_service_duration: MILITARY_SERVICE_DURATIONS
  score: number
}

//-----体育比赛-----

// 体育比赛级别
export enum SPORTS_COMPETITION_LEVELS {
  international = "国际级",
  national = "国家级"
}

// 体育比赛名次
export enum SPORTS_RANKS {
  champion = "冠军",
  runner_up = "亚军",
  third_place = "季军"
}

// 体育比赛类型
export enum SPORTS_TYPES {
  team = "团体",
  individual = "个人"
}

export interface Sports{
  sport_competition_level: SPORTS_COMPETITION_LEVELS
  sport_rank: SPORTS_RANKS
  sport_type: SPORTS_TYPES
}

// 竞赛级别
export const COMPETITION_LEVELS_ARRAY = [
  COMPETITION_LEVELS.A_PLUS,
  COMPETITION_LEVELS.A,
  COMPETITION_LEVELS.A_MINUS
];

// 竞赛等级
export const COMPETITION_GRADES_ARRAY = [
  COMPETITION_GRADES.national,
  COMPETITION_GRADES.provincial
];

// 奖项等级
export const AWARD_LEVELS_ARRAY = [
  AWARD_LEVELS.first,
  AWARD_LEVELS.second,
  AWARD_LEVELS.third
];

// 团队人数
export const TEAM_NUMBER_ARRAY = [
  TEAM_NUMBER.under_5,
  TEAM_NUMBER.over_5
];

// 团队角色
export const TEAM_ROLES_ARRAY = [
  TEAM_ROLES.captain,
  TEAM_ROLES.member_2_3,
  TEAM_ROLES.member_4_5,
  TEAM_ROLES.individual
];

// CCF认证排名
export const CCF_RANKINGS_ARRAY = [
  CCF_RANKINGS.percent_0_2,
  CCF_RANKINGS.percent_1_5,
  CCF_RANKINGS.percent_3
];

// 竞赛类型
export const COMPETITION_TYPES_ARRAY = [
  CompetitionTypes.general,
  CompetitionTypes.ccf
];

// 创新训练级别
export const INNOVATION_LEVELS_ARRAY = [
  INNOVATION_LEVELS.national,
  INNOVATION_LEVELS.provincial,
  INNOVATION_LEVELS.university
];

// 创新训练角色
export const INNOVATION_ROLES_ARRAY = [
  INNOVATION_ROLES.leader,
  INNOVATION_ROLES.member
];

// 论文类别
export const PAPER_CATEGORIES_ARRAY = [
  PAPER_CATEGORIES.A,
  PAPER_CATEGORIES.B,
  PAPER_CATEGORIES.C
];

// 论文作者
export const PAPER_AUTHORS_ARRAY = [
  PAPER_AUTHORS.first_author,
  PAPER_AUTHORS.second_author,
  PAPER_AUTHORS.both_first,
  PAPER_AUTHORS.independent
];

// 专利作者类型
export const PATENT_AUTHOR_TYPES_ARRAY = [
  PATENT_AUTHOR_TYPES.independent,
  PATENT_AUTHOR_TYPES.first_author
];

// 科研成果类型
export const RESEARCH_TYPES_ARRAY = [
  ResearchTypes.paper,
  ResearchTypes.patent
];

// 荣誉称号级别
export const HONOR_TITLE_LEVELS_ARRAY = [
  HONOR_TITLE_LEVELS.national,
  HONOR_TITLE_LEVELS.provincial,
  HONOR_TITLE_LEVELS.university
];

// 志愿服务表彰级别
export const VOLUNTEER_AWARD_LEVELS_ARRAY = [
  VOLUNTEER_AWARD_LEVELS.national,
  VOLUNTEER_AWARD_LEVELS.provincial,
  VOLUNTEER_AWARD_LEVELS.university
];

// 志愿服务角色
export const VOLUNTEER_ROLE_ARRAY = [
  VOLUNTEER_ROLE.leader,
  VOLUNTEER_ROLE.member,
  VOLUNTEER_ROLE.individual
];

// 志愿服务类型
export const VOLUNTEER_TYPES_ARRAY = [
  VolunteerTypes.service,
  VolunteerTypes.award
];

// 实习时长
export const INTERNSHIP_DURATIONS_ARRAY = [
  INTERNSHIP_DURATIONS.full_year,
  INTERNSHIP_DURATIONS.less_than_year
];

// 兵役时长
export const MILITARY_SERVICE_DURATIONS_ARRAY = [
  MILITARY_SERVICE_DURATIONS.years_1_2,
  MILITARY_SERVICE_DURATIONS.over_2_years
];

// 体育比赛级别
export const SPORTS_COMPETITION_LEVELS_ARRAY = [
  SPORTS_COMPETITION_LEVELS.international,
  SPORTS_COMPETITION_LEVELS.national
];

// 体育比赛名次
export const SPORTS_RANKS_ARRAY = [
  SPORTS_RANKS.champion,
  SPORTS_RANKS.runner_up,
  SPORTS_RANKS.third_place
];

// 体育比赛类型
export const SPORTS_TYPES_ARRAY = [
  SPORTS_TYPES.team,
  SPORTS_TYPES.individual
];