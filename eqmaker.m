function out = eqmaker

% 사용할 데이터를 여기에 기록후 명령창에서 '저장할 이름' = eqmaker 실행
% '변수에 대입된 값이 사용되지 않았을 수 있습니다' 경고는 해당 변수를 사용하지 않을 것이 맞다면 무시

% 기본 상수 ▼▼▼▼▼▼▼▼

unitATKp = 0.04954999965; % 단위 공퍼
unitHPp = 0.04954999965; % 단위 체퍼
unitDEFp = 0.06194999907; % 단위 방퍼
unitCR = 0.03304999974; % 단위 치확
unitCD = 0.06604999863; % 단위 치피
unitEM = 19.81499958038; % 단위 원마


mainATKp = 0.465999990702; % 주옵 공퍼
mainHPp = 0.465999990702; % 주옵 체퍼
mainDEFp = 0.583000004292; % 주옵 방퍼
mainCR = 0.310999989510; % 주옵 치확
mainCD = 0.621999979019; % 주옵 치피
mainElBonus = 0.465999990702; % 주옵 피증
mainEM = 186.500000000000; % 주옵 원마

mainStatNum = mainATKp/unitATKp;
unitElBonus = mainElBonus/mainStatNum;

flowerHP = 4780.000000000000; % 꽃 체력
plumeATK = 311.000000000000; % 깃털 공격력

charCR = 0.05; % 캐릭터 기초 치명타 확률
charCD = 0.5; % 캐릭터 기초 치명타 피해

levelCOEF = 1446.85000000000;
% 레벨 계수

spreadCOEF = 1.25; % 발산 계수
bountCOEF = 2;

defCOEF = (90 + 100)/((90 + 100) + (90 + 100));


%--------------------------------------------------------------------------

% 사용자 변수를 여기에 ▼▼▼▼▼▼▼▼

tv.HP = 10875;
tv.ATK = 212.4;
tv.ATKp = 0.24;
tv.q = 1.6032;
tv.a1EM = 6;

tv.a2db = 0.001;
tv.c6db = 0.12;

FavoniusSword.ATK = 454.36; % 무기 공격력
FavoniusSword.ER = 0.6125;

xp.ATK = 509.61
xp.EM = 165.38
xp.ERb = 0.00036
%--------------------------------------------------------------------------





%--------------------------------------------------------------------------
% 수식을 여기에 ▼▼▼▼▼▼▼▼

% x:공퍼 y:치명 z:원마 u:피증

fs.ATK = @(x) (tv.ATK + FavoniusSword.ATK)*(1 + tv.ATKp + unitATKp*x) + plumeATK;

% 치명타 식
fs.baseCR = charCR;
fs.baseCD = charCD;

fs.numCR = @(y) (fs.baseCD - 2*fs.baseCR + unitCD*y)/(2*unitCR + unitCD); % 치명타 압축식 1
fs.numCD = @(y) (-fs.baseCD + 2*fs.baseCR + 2*unitCR*y)/(2*unitCR + unitCD); % 치명타 압축식 2
fs.CR = @(y) fs.baseCR + unitCR*fs.numCR(y); % 치명타 확률
fs.CD = @(y) fs.baseCD + unitCD*fs.numCD(y); % 치명타 피해
fs.CRIT = @(y) 1 + fs.CR(y)*fs.CD(y); % 치명타 계수

fs.EM = @(z) 1 + unitEM*z;
fs.EM_zu = @(z) 1 + unitEM*z;

fs.dmg_bonus = @(z,u) 1 + unitElBonus*u + fs.EM(z)*tv.a2db + tv.c6db; % 피해 증가
fs.dmg_bonus_zu = @(z,u) 1 + mainElBonus + 0.15 + unitElBonus*u + fs.EM_zu(z)*tv.a2db + tv.c6db; % 피해 증가

% 발산 대미지
fs.sprd = @(z) spreadCOEF*levelCOEF*(1 + (5*fs.EM(z)) / (1200 + fs.EM(z)));
fs.sprd_zu = @(z) spreadCOEF*levelCOEF*(1 + (5*fs.EM_zu(z)) / (1200 + fs.EM_zu(z)));
% 풍요 대미지
fs.bount = @(z) bountCOEF*levelCOEF*(1 + (16*fs.EM(z)) / (2000 + fs.EM(z)));

%--------------------------------------------------------------------------

fs.q_dmg = @(x,z) 2*fs.ATK(x)*tv.q + fs.sprd(z);
fs.tvbase = @(x,y,z,u) fs.q_dmg(x,z)*fs.CRIT(y)*fs.dmg_bonus(z,u);

%out = fs.tvbase;


fs.tvbase_u = @(x,y,z) (2*fs.ATK(x)*tv.q + fs.sprd_zu(z))*fs.CRIT(y)*fs.dmg_bonus_zu(z,0);
%out = fs.tvbase_u;


fs.q_dmg_nosprd = @(x,y,z,u) fs.ATK(x)*tv.q*fs.CRIT(y)*fs.dmg_bonus(z,u)*defCOEF;
fs.q_dmg_nosprd_u = @(x,y,z,u) fs.ATK(x)*tv.q*fs.CRIT(y)*fs.dmg_bonus_zu(z,u)*defCOEF;

%out{1} = @(x,y,z,u) 2*fs.q_dmg_nosprd(x,y,z,u) + fs.bount(z);
%out{2} = @(x,y,z,u) 8*fs.q_dmg_nosprd(x,y,z,u) + fs.bount(z);
%out = @(x,z,u) 8*fs.q_dmg_nosprd(x,0,z,u) + fs.bount(z);
%out = @(x,y,z) 8*fs.q_dmg_nosprd_u(x,y,z,0) + fs.bount(z);

%out{1} = @(x,z) 8*fs.q_dmg_nosprd(x,0,z + 19.4,3.027) + fs.bount(z + 19.4);
%out{2} = @(x,y) 8*fs.q_dmg_nosprd(x,y,10,12.427) + fs.bount(10);

out{1} = @(x,z) fs.q_dmg_nosprd(0,0,z + 19.4,3.027);
out{2} = @(x,y) fs.q_dmg_nosprd(x,y,10,12.427);

%% 최종 방정식을 여기에 ▼▼▼▼▼▼▼▼

%out.eq_base = fs.tvbase;
%out.eq_u = fs.tvbase_u;

end