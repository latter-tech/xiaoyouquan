// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Following`
  String get following {
    return Intl.message(
      'Following',
      name: 'following',
      desc: '',
      args: [],
    );
  }

  /// `My follow`
  String get my_follow {
    return Intl.message(
      'My follow',
      name: 'my_follow',
      desc: '',
      args: [],
    );
  }

  /// `Followed`
  String get followed {
    return Intl.message(
      'Followed',
      name: 'followed',
      desc: '',
      args: [],
    );
  }

  /// `Lawen`
  String get blogs {
    return Intl.message(
      'Lawen',
      name: 'blogs',
      desc: '',
      args: [],
    );
  }

  /// `Lawen&Replies`
  String get blogs_and_replies {
    return Intl.message(
      'Lawen&Replies',
      name: 'blogs_and_replies',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get likes {
    return Intl.message(
      'Likes',
      name: 'likes',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Intro`
  String get intro {
    return Intl.message(
      'Intro',
      name: 'intro',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Signup date`
  String get signup_date {
    return Intl.message(
      'Signup date',
      name: 'signup_date',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get date_of_birth {
    return Intl.message(
      'Date of birth',
      name: 'date_of_birth',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Your account`
  String get your_account {
    return Intl.message(
      'Your account',
      name: 'your_account',
      desc: '',
      args: [],
    );
  }

  /// `See information about your account`
  String get see_information_about_your_account {
    return Intl.message(
      'See information about your account',
      name: 'see_information_about_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Update password`
  String get update_password {
    return Intl.message(
      'Update password',
      name: 'update_password',
      desc: '',
      args: [],
    );
  }

  /// `Select language`
  String get select_language {
    return Intl.message(
      'Select language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `Chinese and English only`
  String get chinese_and_english_only {
    return Intl.message(
      'Chinese and English only',
      name: 'chinese_and_english_only',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get current_password {
    return Intl.message(
      'Current password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get new_password {
    return Intl.message(
      'New password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `At least 8 characters`
  String get at_least_8_characters {
    return Intl.message(
      'At least 8 characters',
      name: 'at_least_8_characters',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Recommend`
  String get for_you {
    return Intl.message(
      'Recommend',
      name: 'for_you',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `User Agreement`
  String get user_agreement {
    return Intl.message(
      'User Agreement',
      name: 'user_agreement',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get followers {
    return Intl.message(
      'Followers',
      name: 'followers',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Search Messages`
  String get search_messages {
    return Intl.message(
      'Search Messages',
      name: 'search_messages',
      desc: '',
      args: [],
    );
  }

  /// `Lawen`
  String get lawen {
    return Intl.message(
      'Lawen',
      name: 'lawen',
      desc: '',
      args: [],
    );
  }

  /// `Joined`
  String get joined {
    return Intl.message(
      'Joined',
      name: 'joined',
      desc: '',
      args: [],
    );
  }

  /// `Deactivate your account`
  String get deactivate_your_account {
    return Intl.message(
      'Deactivate your account',
      name: 'deactivate_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Deactivating your account will permanently remove all your data and cannot be undone. Are you sure you want to proceed?`
  String get deactivate_warning {
    return Intl.message(
      'Deactivating your account will permanently remove all your data and cannot be undone. Are you sure you want to proceed?',
      name: 'deactivate_warning',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deactivation`
  String get deactivate_confirm {
    return Intl.message(
      'Confirm Deactivation',
      name: 'deactivate_confirm',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone.  Are you sure you want to continue?`
  String get deactivate_cannot_be_undone {
    return Intl.message(
      'This action cannot be undone.  Are you sure you want to continue?',
      name: 'deactivate_cannot_be_undone',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enter_your_password {
    return Intl.message(
      'Enter your password',
      name: 'enter_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Cell phone number`
  String get cell_phone_number {
    return Intl.message(
      'Cell phone number',
      name: 'cell_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Select the location`
  String get select_location {
    return Intl.message(
      'Select the location',
      name: 'select_location',
      desc: '',
      args: [],
    );
  }

  /// `Repost`
  String get repost {
    return Intl.message(
      'Repost',
      name: 'repost',
      desc: '',
      args: [],
    );
  }

  /// `Undo Repost`
  String get undo_repost {
    return Intl.message(
      'Undo Repost',
      name: 'undo_repost',
      desc: '',
      args: [],
    );
  }

  /// `Quote Post`
  String get quote {
    return Intl.message(
      'Quote Post',
      name: 'quote',
      desc: '',
      args: [],
    );
  }

  /// `Reposted`
  String get reposted {
    return Intl.message(
      'Reposted',
      name: 'reposted',
      desc: '',
      args: [],
    );
  }

  /// `No Notification available yet`
  String get no_notification_available_yet {
    return Intl.message(
      'No Notification available yet',
      name: 'no_notification_available_yet',
      desc: '',
      args: [],
    );
  }

  /// `When new notification found,\nthey'll show up here.`
  String get when_new_notification_found {
    return Intl.message(
      'When new notification found,\nthey\'ll show up here.',
      name: 'when_new_notification_found',
      desc: '',
      args: [],
    );
  }

  /// `No Conversations yet`
  String get no_conversations_yet {
    return Intl.message(
      'No Conversations yet',
      name: 'no_conversations_yet',
      desc: '',
      args: [],
    );
  }

  /// `Start chatting with someone \nand your conversations will appear here.`
  String get start_chatting_with_someone {
    return Intl.message(
      'Start chatting with someone \nand your conversations will appear here.',
      name: 'start_chatting_with_someone',
      desc: '',
      args: [],
    );
  }

  /// `{value} {unit} ago`
  String timeAgo(Object value, Object unit) {
    return Intl.message(
      '$value $unit ago',
      name: 'timeAgo',
      desc: 'Displays time ago, like \'2 days ago\'',
      args: [value, unit],
    );
  }

  /// `just now`
  String get justNow {
    return Intl.message(
      'just now',
      name: 'justNow',
      desc: '',
      args: [],
    );
  }

  /// `year`
  String get year {
    return Intl.message(
      'year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `years`
  String get years {
    return Intl.message(
      'years',
      name: 'years',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message(
      'month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `months`
  String get months {
    return Intl.message(
      'months',
      name: 'months',
      desc: '',
      args: [],
    );
  }

  /// `week`
  String get week {
    return Intl.message(
      'week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `weeks`
  String get weeks {
    return Intl.message(
      'weeks',
      name: 'weeks',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `hour`
  String get hour {
    return Intl.message(
      'hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get hours {
    return Intl.message(
      'hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `minute`
  String get minute {
    return Intl.message(
      'minute',
      name: 'minute',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Pull to refresh`
  String get pullToRefresh {
    return Intl.message(
      'Pull to refresh',
      name: 'pullToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get refreshing {
    return Intl.message(
      'Refreshing...',
      name: 'refreshing',
      desc: '',
      args: [],
    );
  }

  /// `Refresh completed`
  String get refreshCompleted {
    return Intl.message(
      'Refresh completed',
      name: 'refreshCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Refresh failed`
  String get refreshFailed {
    return Intl.message(
      'Refresh failed',
      name: 'refreshFailed',
      desc: '',
      args: [],
    );
  }

  /// `No more data`
  String get noMore {
    return Intl.message(
      'No more data',
      name: 'noMore',
      desc: '',
      args: [],
    );
  }

  /// `Last updated at %T`
  String get last_updated_at {
    return Intl.message(
      'Last updated at %T',
      name: 'last_updated_at',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to delete it?`
  String get are_you_sure_want_to_delete_it {
    return Intl.message(
      'Are you sure want to delete it?',
      name: 'are_you_sure_want_to_delete_it',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
