import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your AI-powered career guide'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Built for Algerian students.\nFind your path, close your gaps.'**
  String get welcomeTagline;

  /// No description provided for @welcomeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get welcomeGetStarted;

  /// No description provided for @welcomeSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now →'**
  String get welcomeSkipForNow;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageMeta.
  ///
  /// In en, this message translates to:
  /// **'اختر لغتك  •  Choisissez votre langue'**
  String get languageMeta;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get commonOptional;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get commonSearch;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonBuildPlan.
  ///
  /// In en, this message translates to:
  /// **'Build my plan →'**
  String get commonBuildPlan;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get to know you'**
  String get step1Title;

  /// No description provided for @step1Microcopy.
  ///
  /// In en, this message translates to:
  /// **'Used to personalize your results — never shared'**
  String get step1Microcopy;

  /// No description provided for @step1FullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get step1FullName;

  /// No description provided for @step1FullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get step1FullNameHint;

  /// No description provided for @step1BirthYear.
  ///
  /// In en, this message translates to:
  /// **'Birth Year'**
  String get step1BirthYear;

  /// No description provided for @step1BirthYearPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select your birth year'**
  String get step1BirthYearPlaceholder;

  /// No description provided for @step1Gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get step1Gender;

  /// No description provided for @step1Male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get step1Male;

  /// No description provided for @step1Female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get step1Female;

  /// No description provided for @step1Wilaya.
  ///
  /// In en, this message translates to:
  /// **'Wilaya'**
  String get step1Wilaya;

  /// No description provided for @step1WilayaPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select your wilaya'**
  String get step1WilayaPlaceholder;

  /// No description provided for @step1Commune.
  ///
  /// In en, this message translates to:
  /// **'Commune'**
  String get step1Commune;

  /// No description provided for @step1CommunePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select your commune'**
  String get step1CommunePlaceholder;

  /// No description provided for @step1CommuneSelectFirst.
  ///
  /// In en, this message translates to:
  /// **'Select wilaya first'**
  String get step1CommuneSelectFirst;

  /// No description provided for @step1Email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get step1Email;

  /// No description provided for @step1EmailHint.
  ///
  /// In en, this message translates to:
  /// **'your@email.com'**
  String get step1EmailHint;

  /// No description provided for @step1Phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get step1Phone;

  /// No description provided for @step1PhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+213 or 0xxx...'**
  String get step1PhoneHint;

  /// No description provided for @step1Password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get step1Password;

  /// No description provided for @step1PasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Min 8 characters'**
  String get step1PasswordHint;

  /// No description provided for @step1ConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get step1ConfirmPassword;

  /// No description provided for @step1ConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat your password'**
  String get step1ConfirmPasswordHint;

  /// No description provided for @step1PasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get step1PasswordWeak;

  /// No description provided for @step1PasswordFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get step1PasswordFair;

  /// No description provided for @step1PasswordStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get step1PasswordStrong;

  /// No description provided for @step1PasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get step1PasswordMismatch;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Your academic journey'**
  String get step2Title;

  /// No description provided for @step2Microcopy.
  ///
  /// In en, this message translates to:
  /// **'Helps us match you with the right majors'**
  String get step2Microcopy;

  /// No description provided for @step2BacStream.
  ///
  /// In en, this message translates to:
  /// **'Baccalauréat Stream'**
  String get step2BacStream;

  /// No description provided for @step2BacYear.
  ///
  /// In en, this message translates to:
  /// **'Bac Year'**
  String get step2BacYear;

  /// No description provided for @step2BacYearHint.
  ///
  /// In en, this message translates to:
  /// **'Year you passed the bac'**
  String get step2BacYearHint;

  /// No description provided for @step2BacAverage.
  ///
  /// In en, this message translates to:
  /// **'Bac Average'**
  String get step2BacAverage;

  /// No description provided for @step2BacAverageInvalid.
  ///
  /// In en, this message translates to:
  /// **'Average must be at least 10/20'**
  String get step2BacAverageInvalid;

  /// No description provided for @step2StrongSubjects.
  ///
  /// In en, this message translates to:
  /// **'Strong subjects (max 3)'**
  String get step2StrongSubjects;

  /// No description provided for @step2WeakSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects to improve'**
  String get step2WeakSubjects;

  /// No description provided for @step2EnrolledToggle.
  ///
  /// In en, this message translates to:
  /// **'Already enrolled at university?'**
  String get step2EnrolledToggle;

  /// No description provided for @step2CurrentMajor.
  ///
  /// In en, this message translates to:
  /// **'Current Major'**
  String get step2CurrentMajor;

  /// No description provided for @step2CurrentMajorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Computer Science'**
  String get step2CurrentMajorHint;

  /// No description provided for @step2UniversityYear.
  ///
  /// In en, this message translates to:
  /// **'University Year'**
  String get step2UniversityYear;

  /// No description provided for @step2LmdSystem.
  ///
  /// In en, this message translates to:
  /// **'LMD System'**
  String get step2LmdSystem;

  /// No description provided for @step2EngineerSystem.
  ///
  /// In en, this message translates to:
  /// **'Grandes Écoles / Engineering'**
  String get step2EngineerSystem;

  /// No description provided for @step2Extracurriculars.
  ///
  /// In en, this message translates to:
  /// **'Extracurriculars (optional, max 5)'**
  String get step2Extracurriculars;

  /// No description provided for @step2ExtracurricularsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. robotics club, debate...'**
  String get step2ExtracurricularsHint;

  /// No description provided for @bacStreamMath.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get bacStreamMath;

  /// No description provided for @bacStreamSciences.
  ///
  /// In en, this message translates to:
  /// **'Natural Sciences'**
  String get bacStreamSciences;

  /// No description provided for @bacStreamTechMath.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get bacStreamTechMath;

  /// No description provided for @bacStreamLiterature.
  ///
  /// In en, this message translates to:
  /// **'Literature & Philosophy'**
  String get bacStreamLiterature;

  /// No description provided for @bacStreamLanguages.
  ///
  /// In en, this message translates to:
  /// **'Foreign Languages'**
  String get bacStreamLanguages;

  /// No description provided for @bacStreamManagement.
  ///
  /// In en, this message translates to:
  /// **'Management & Economics'**
  String get bacStreamManagement;

  /// No description provided for @bacStreamIslamic.
  ///
  /// In en, this message translates to:
  /// **'Islamic Sciences'**
  String get bacStreamIslamic;

  /// No description provided for @mentionInvalid.
  ///
  /// In en, this message translates to:
  /// **'Not admitted'**
  String get mentionInvalid;

  /// No description provided for @mentionPassable.
  ///
  /// In en, this message translates to:
  /// **'Passable'**
  String get mentionPassable;

  /// No description provided for @mentionAssezBien.
  ///
  /// In en, this message translates to:
  /// **'Satisfactory'**
  String get mentionAssezBien;

  /// No description provided for @mentionBien.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get mentionBien;

  /// No description provided for @mentionTresBien.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get mentionTresBien;

  /// No description provided for @mentionFelicitations.
  ///
  /// In en, this message translates to:
  /// **'With Honors'**
  String get mentionFelicitations;

  /// No description provided for @subjectMaths.
  ///
  /// In en, this message translates to:
  /// **'Mathematics'**
  String get subjectMaths;

  /// No description provided for @subjectPhysics.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get subjectPhysics;

  /// No description provided for @subjectArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get subjectArabic;

  /// No description provided for @subjectFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get subjectFrench;

  /// No description provided for @subjectEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get subjectEnglish;

  /// No description provided for @subjectHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get subjectHistory;

  /// No description provided for @subjectBiology.
  ///
  /// In en, this message translates to:
  /// **'Biology'**
  String get subjectBiology;

  /// No description provided for @subjectChemistry.
  ///
  /// In en, this message translates to:
  /// **'Chemistry'**
  String get subjectChemistry;

  /// No description provided for @subjectPhilosophy.
  ///
  /// In en, this message translates to:
  /// **'Philosophy'**
  String get subjectPhilosophy;

  /// No description provided for @subjectEconomics.
  ///
  /// In en, this message translates to:
  /// **'Economics'**
  String get subjectEconomics;

  /// No description provided for @subjectComputerScience.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get subjectComputerScience;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'What drives you?'**
  String get step3Title;

  /// No description provided for @step3Microcopy.
  ///
  /// In en, this message translates to:
  /// **'The more honest you are, the better your results'**
  String get step3Microcopy;

  /// No description provided for @step3DomainsLabel.
  ///
  /// In en, this message translates to:
  /// **'Fields that interest you (pick up to 3)'**
  String get step3DomainsLabel;

  /// No description provided for @step3ActivitiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Activities you enjoy (optional)'**
  String get step3ActivitiesLabel;

  /// No description provided for @step3WorkStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'How do you like to work?'**
  String get step3WorkStyleLabel;

  /// No description provided for @step3EnvironmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred work environment'**
  String get step3EnvironmentLabel;

  /// No description provided for @step3GoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Short-term goal after graduation'**
  String get step3GoalLabel;

  /// No description provided for @step3SectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred sector'**
  String get step3SectorLabel;

  /// No description provided for @step3SalaryLabel.
  ///
  /// In en, this message translates to:
  /// **'How important is salary?'**
  String get step3SalaryLabel;

  /// No description provided for @step3ExtraLabel.
  ///
  /// In en, this message translates to:
  /// **'Anything else? (optional)'**
  String get step3ExtraLabel;

  /// No description provided for @step3ExtraHint.
  ///
  /// In en, this message translates to:
  /// **'I want to be like...'**
  String get step3ExtraHint;

  /// No description provided for @step3SalaryLow.
  ///
  /// In en, this message translates to:
  /// **'Not Priority'**
  String get step3SalaryLow;

  /// No description provided for @step3SalaryMedium.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get step3SalaryMedium;

  /// No description provided for @step3SalaryHigh.
  ///
  /// In en, this message translates to:
  /// **'Top Priority'**
  String get step3SalaryHigh;

  /// No description provided for @sectorPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get sectorPublic;

  /// No description provided for @sectorPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get sectorPrivate;

  /// No description provided for @sectorBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get sectorBoth;

  /// No description provided for @sectorNgo.
  ///
  /// In en, this message translates to:
  /// **'NGO'**
  String get sectorNgo;

  /// No description provided for @goalGetJob.
  ///
  /// In en, this message translates to:
  /// **'Get a job'**
  String get goalGetJob;

  /// No description provided for @goalGetJobDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the workforce asap'**
  String get goalGetJobDesc;

  /// No description provided for @goalMasters.
  ///
  /// In en, this message translates to:
  /// **'Continue to Master\'s'**
  String get goalMasters;

  /// No description provided for @goalMastersDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay in academia, specialize'**
  String get goalMastersDesc;

  /// No description provided for @goalPhd.
  ///
  /// In en, this message translates to:
  /// **'Pursue a PhD'**
  String get goalPhd;

  /// No description provided for @goalPhdDesc.
  ///
  /// In en, this message translates to:
  /// **'Research and academic career'**
  String get goalPhdDesc;

  /// No description provided for @goalBusiness.
  ///
  /// In en, this message translates to:
  /// **'Start a business'**
  String get goalBusiness;

  /// No description provided for @goalBusinessDesc.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneurship path'**
  String get goalBusinessDesc;

  /// No description provided for @goalEmigrate.
  ///
  /// In en, this message translates to:
  /// **'Work abroad'**
  String get goalEmigrate;

  /// No description provided for @goalEmigrateDesc.
  ///
  /// In en, this message translates to:
  /// **'International opportunities'**
  String get goalEmigrateDesc;

  /// No description provided for @workStyleSolo.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get workStyleSolo;

  /// No description provided for @workStyleTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get workStyleTeam;

  /// No description provided for @workStyleCreative.
  ///
  /// In en, this message translates to:
  /// **'Creative'**
  String get workStyleCreative;

  /// No description provided for @workStyleAnalytical.
  ///
  /// In en, this message translates to:
  /// **'Analytical'**
  String get workStyleAnalytical;

  /// No description provided for @workStyleHandsOn.
  ///
  /// In en, this message translates to:
  /// **'Hands-on'**
  String get workStyleHandsOn;

  /// No description provided for @workStyleResearch.
  ///
  /// In en, this message translates to:
  /// **'Research'**
  String get workStyleResearch;

  /// No description provided for @workStyleManagement.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get workStyleManagement;

  /// No description provided for @envOffice.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get envOffice;

  /// No description provided for @envField.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get envField;

  /// No description provided for @envLab.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get envLab;

  /// No description provided for @envRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get envRemote;

  /// No description provided for @envHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get envHospital;

  /// No description provided for @envSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get envSchool;

  /// No description provided for @envOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor'**
  String get envOutdoor;

  /// No description provided for @domainTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get domainTechnology;

  /// No description provided for @domainMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get domainMedicine;

  /// No description provided for @domainLaw.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get domainLaw;

  /// No description provided for @domainEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get domainEngineering;

  /// No description provided for @domainBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get domainBusiness;

  /// No description provided for @domainArts.
  ///
  /// In en, this message translates to:
  /// **'Arts'**
  String get domainArts;

  /// No description provided for @domainEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get domainEducation;

  /// No description provided for @domainScience.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get domainScience;

  /// No description provided for @domainAgriculture.
  ///
  /// In en, this message translates to:
  /// **'Agriculture'**
  String get domainAgriculture;

  /// No description provided for @domainArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get domainArchitecture;

  /// No description provided for @domainSportScience.
  ///
  /// In en, this message translates to:
  /// **'Sport Science'**
  String get domainSportScience;

  /// No description provided for @domainJournalism.
  ///
  /// In en, this message translates to:
  /// **'Journalism'**
  String get domainJournalism;

  /// No description provided for @actBuildingThings.
  ///
  /// In en, this message translates to:
  /// **'Building things'**
  String get actBuildingThings;

  /// No description provided for @actHelpingPeople.
  ///
  /// In en, this message translates to:
  /// **'Helping people'**
  String get actHelpingPeople;

  /// No description provided for @actWriting.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get actWriting;

  /// No description provided for @actAnalyzingData.
  ///
  /// In en, this message translates to:
  /// **'Analyzing data'**
  String get actAnalyzingData;

  /// No description provided for @actDesigning.
  ///
  /// In en, this message translates to:
  /// **'Designing'**
  String get actDesigning;

  /// No description provided for @actTeaching.
  ///
  /// In en, this message translates to:
  /// **'Teaching'**
  String get actTeaching;

  /// No description provided for @actResearching.
  ///
  /// In en, this message translates to:
  /// **'Researching'**
  String get actResearching;

  /// No description provided for @actOrganizing.
  ///
  /// In en, this message translates to:
  /// **'Organizing'**
  String get actOrganizing;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Where are you?'**
  String get step4Title;

  /// No description provided for @step4Microcopy.
  ///
  /// In en, this message translates to:
  /// **'Helps us find universities and internships near you'**
  String get step4Microcopy;

  /// No description provided for @step4HomeWilaya.
  ///
  /// In en, this message translates to:
  /// **'Home Wilaya'**
  String get step4HomeWilaya;

  /// No description provided for @step4HomeCommune.
  ///
  /// In en, this message translates to:
  /// **'Home Commune'**
  String get step4HomeCommune;

  /// No description provided for @step4TransportLabel.
  ///
  /// In en, this message translates to:
  /// **'How do you get around?'**
  String get step4TransportLabel;

  /// No description provided for @step4MaxCommute.
  ///
  /// In en, this message translates to:
  /// **'Max one-way commute'**
  String get step4MaxCommute;

  /// No description provided for @step4PersonalTransport.
  ///
  /// In en, this message translates to:
  /// **'I own a car or motorcycle'**
  String get step4PersonalTransport;

  /// No description provided for @step4RelocateLabel.
  ///
  /// In en, this message translates to:
  /// **'Willing to relocate?'**
  String get step4RelocateLabel;

  /// No description provided for @step4Housing.
  ///
  /// In en, this message translates to:
  /// **'Open to cité universitaire (student housing)'**
  String get step4Housing;

  /// No description provided for @step4UniTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred institution type (optional)'**
  String get step4UniTypeLabel;

  /// No description provided for @step4StudyLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred language of study'**
  String get step4StudyLanguageLabel;

  /// No description provided for @transportCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get transportCar;

  /// No description provided for @transportBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get transportBus;

  /// No description provided for @transportTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get transportTrain;

  /// No description provided for @transportTaxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get transportTaxi;

  /// No description provided for @transportWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get transportWalk;

  /// No description provided for @transportMoto.
  ///
  /// In en, this message translates to:
  /// **'Moto'**
  String get transportMoto;

  /// No description provided for @relocateNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get relocateNo;

  /// No description provided for @relocateNoDesc.
  ///
  /// In en, this message translates to:
  /// **'Stay in my current commune'**
  String get relocateNoDesc;

  /// No description provided for @relocateSameWilaya.
  ///
  /// In en, this message translates to:
  /// **'Same wilaya'**
  String get relocateSameWilaya;

  /// No description provided for @relocateSameWilayaDesc.
  ///
  /// In en, this message translates to:
  /// **'Move within my wilaya'**
  String get relocateSameWilayaDesc;

  /// No description provided for @relocateNearby.
  ///
  /// In en, this message translates to:
  /// **'Nearby wilayas'**
  String get relocateNearby;

  /// No description provided for @relocateNearbyDesc.
  ///
  /// In en, this message translates to:
  /// **'Up to 2-3 wilayas away'**
  String get relocateNearbyDesc;

  /// No description provided for @relocateAnywhere.
  ///
  /// In en, this message translates to:
  /// **'Anywhere in Algeria'**
  String get relocateAnywhere;

  /// No description provided for @relocateAnywhereDesc.
  ///
  /// In en, this message translates to:
  /// **'Open to any location'**
  String get relocateAnywhereDesc;

  /// No description provided for @uniTypeAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get uniTypeAny;

  /// No description provided for @uniTypeUniversity.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get uniTypeUniversity;

  /// No description provided for @uniTypeEcole.
  ///
  /// In en, this message translates to:
  /// **'École Supérieure'**
  String get uniTypeEcole;

  /// No description provided for @uniTypeInstitute.
  ///
  /// In en, this message translates to:
  /// **'Institut'**
  String get uniTypeInstitute;

  /// No description provided for @uniTypeGrandeEcole.
  ///
  /// In en, this message translates to:
  /// **'Grande École'**
  String get uniTypeGrandeEcole;

  /// No description provided for @studyLangArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get studyLangArabic;

  /// No description provided for @studyLangFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get studyLangFrench;

  /// No description provided for @studyLangEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get studyLangEnglish;

  /// No description provided for @studyLangBilingual.
  ///
  /// In en, this message translates to:
  /// **'Bilingual'**
  String get studyLangBilingual;

  /// No description provided for @step5Title.
  ///
  /// In en, this message translates to:
  /// **'How do you learn best?'**
  String get step5Title;

  /// No description provided for @step5Microcopy.
  ///
  /// In en, this message translates to:
  /// **'We\'ll build your study plan around your real lifestyle'**
  String get step5Microcopy;

  /// No description provided for @step5StudyHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Study hours per day'**
  String get step5StudyHoursLabel;

  /// No description provided for @step5LearningStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Learning style (optional)'**
  String get step5LearningStyleLabel;

  /// No description provided for @step5ResourceLangLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred language for resources'**
  String get step5ResourceLangLabel;

  /// No description provided for @step5Internet.
  ///
  /// In en, this message translates to:
  /// **'I have reliable internet access'**
  String get step5Internet;

  /// No description provided for @step5InternetMicro.
  ///
  /// In en, this message translates to:
  /// **'We\'ll suggest offline resources'**
  String get step5InternetMicro;

  /// No description provided for @step5Paid.
  ///
  /// In en, this message translates to:
  /// **'I can afford paid courses'**
  String get step5Paid;

  /// No description provided for @step5PaidMicro.
  ///
  /// In en, this message translates to:
  /// **'We\'ll focus on free resources only'**
  String get step5PaidMicro;

  /// No description provided for @step5ConcernLabel.
  ///
  /// In en, this message translates to:
  /// **'My biggest concern'**
  String get step5ConcernLabel;

  /// No description provided for @step5ConcernHint.
  ///
  /// In en, this message translates to:
  /// **'My biggest worry is...'**
  String get step5ConcernHint;

  /// No description provided for @step5NotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Anything else I should know'**
  String get step5NotesLabel;

  /// No description provided for @step5NotesHint.
  ///
  /// In en, this message translates to:
  /// **'Anything else...'**
  String get step5NotesHint;

  /// No description provided for @learningVisual.
  ///
  /// In en, this message translates to:
  /// **'Visual'**
  String get learningVisual;

  /// No description provided for @learningAuditory.
  ///
  /// In en, this message translates to:
  /// **'Auditory'**
  String get learningAuditory;

  /// No description provided for @learningReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get learningReading;

  /// No description provided for @learningHandsOn.
  ///
  /// In en, this message translates to:
  /// **'Hands-on'**
  String get learningHandsOn;

  /// No description provided for @resourceArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get resourceArabic;

  /// No description provided for @resourceFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get resourceFrench;

  /// No description provided for @resourceEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get resourceEnglish;

  /// No description provided for @resourceMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get resourceMixed;

  /// No description provided for @processingTitle.
  ///
  /// In en, this message translates to:
  /// **'Building your profile...'**
  String get processingTitle;

  /// No description provided for @processingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Our AI is analyzing your answers'**
  String get processingSubtitle;

  /// No description provided for @processingMajors.
  ///
  /// In en, this message translates to:
  /// **'Suggesting best majors'**
  String get processingMajors;

  /// No description provided for @processingTravel.
  ///
  /// In en, this message translates to:
  /// **'Calculating travel times'**
  String get processingTravel;

  /// No description provided for @processingInternships.
  ///
  /// In en, this message translates to:
  /// **'Searching internships'**
  String get processingInternships;

  /// No description provided for @processingResources.
  ///
  /// In en, this message translates to:
  /// **'Curating resources'**
  String get processingResources;

  /// No description provided for @processingPlan.
  ///
  /// In en, this message translates to:
  /// **'Building study plan'**
  String get processingPlan;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeCareerMatch.
  ///
  /// In en, this message translates to:
  /// **'Career Match'**
  String get homeCareerMatch;

  /// No description provided for @homeSkillsFilled.
  ///
  /// In en, this message translates to:
  /// **'Skills Filled'**
  String get homeSkillsFilled;

  /// No description provided for @homePlanProgress.
  ///
  /// In en, this message translates to:
  /// **'Plan Progress'**
  String get homePlanProgress;

  /// No description provided for @homeServiceCareer.
  ///
  /// In en, this message translates to:
  /// **'Career Path'**
  String get homeServiceCareer;

  /// No description provided for @homeServiceCareerDesc.
  ///
  /// In en, this message translates to:
  /// **'Find your best major match'**
  String get homeServiceCareerDesc;

  /// No description provided for @homeServiceMatrix.
  ///
  /// In en, this message translates to:
  /// **'Subject Matrix'**
  String get homeServiceMatrix;

  /// No description provided for @homeServiceMatrixDesc.
  ///
  /// In en, this message translates to:
  /// **'Understand why each course matters'**
  String get homeServiceMatrixDesc;

  /// No description provided for @homeServiceSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills Gap'**
  String get homeServiceSkills;

  /// No description provided for @homeServiceSkillsDesc.
  ///
  /// In en, this message translates to:
  /// **'See what skills you\'re missing'**
  String get homeServiceSkillsDesc;

  /// No description provided for @homeServiceInternship.
  ///
  /// In en, this message translates to:
  /// **'Internship Guide'**
  String get homeServiceInternship;

  /// No description provided for @homeServiceInternshipDesc.
  ///
  /// In en, this message translates to:
  /// **'Companies ready to hire you now'**
  String get homeServiceInternshipDesc;

  /// No description provided for @homeServicePlan.
  ///
  /// In en, this message translates to:
  /// **'Study Plan'**
  String get homeServicePlan;

  /// No description provided for @homeServicePlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Weekly schedule to close your gaps'**
  String get homeServicePlanDesc;

  /// No description provided for @homeAskAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI anything'**
  String get homeAskAi;

  /// No description provided for @homeUploadTranscript.
  ///
  /// In en, this message translates to:
  /// **'Upload transcript'**
  String get homeUploadTranscript;

  /// No description provided for @homeViewPlan.
  ///
  /// In en, this message translates to:
  /// **'View my plan'**
  String get homeViewPlan;

  /// No description provided for @homeNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavHome;

  /// No description provided for @homeNavChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get homeNavChat;

  /// No description provided for @homeNavGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get homeNavGuide;

  /// No description provided for @homeNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get homeNavProfile;

  /// No description provided for @homeServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get homeServices;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileAppSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get profileAppSettings;

  /// No description provided for @profileDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profileDarkMode;

  /// No description provided for @profileLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get profileLightMode;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profilePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profilePersonalInfo;

  /// No description provided for @profileAcademicInfo.
  ///
  /// In en, this message translates to:
  /// **'Academic Background'**
  String get profileAcademicInfo;

  /// No description provided for @profileDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get profileDangerZone;

  /// No description provided for @profileReset.
  ///
  /// In en, this message translates to:
  /// **'Reset Profile'**
  String get profileReset;

  /// No description provided for @profileResetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reset'**
  String get profileResetConfirmTitle;

  /// No description provided for @profileResetConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All your data will be deleted and you will be taken back to the start. Are you sure?'**
  String get profileResetConfirmBody;

  /// No description provided for @profileResetCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileResetCancel;

  /// No description provided for @profileResetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileResetConfirm;

  /// No description provided for @profileFieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileFieldFullName;

  /// No description provided for @profileFieldBirthYear.
  ///
  /// In en, this message translates to:
  /// **'Birth Year'**
  String get profileFieldBirthYear;

  /// No description provided for @profileFieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get profileFieldGender;

  /// No description provided for @profileFieldWilaya.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get profileFieldWilaya;

  /// No description provided for @profileFieldBacStream.
  ///
  /// In en, this message translates to:
  /// **'Bac Stream'**
  String get profileFieldBacStream;

  /// No description provided for @profileFieldBacAverage.
  ///
  /// In en, this message translates to:
  /// **'Bac Average'**
  String get profileFieldBacAverage;

  /// No description provided for @profileFieldMajor.
  ///
  /// In en, this message translates to:
  /// **'Current Major'**
  String get profileFieldMajor;

  /// No description provided for @profileFieldYear.
  ///
  /// In en, this message translates to:
  /// **'University Year'**
  String get profileFieldYear;

  /// No description provided for @profileFieldNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get profileFieldNotSet;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit field'**
  String get profileEditTitle;

  /// No description provided for @profileEditSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profileEditSave;

  /// No description provided for @profileStepsCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count} / 5 steps completed'**
  String profileStepsCompleted(int count);

  /// No description provided for @profileContinueFilling.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get profileContinueFilling;

  /// No description provided for @profileContinueFillingDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re almost there! Finish filling your profile to unlock personalized recommendations.'**
  String get profileContinueFillingDesc;

  /// No description provided for @profileContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue where I left off'**
  String get profileContinueButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
