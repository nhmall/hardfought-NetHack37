/* macsound.m */
/* Copyright Michael Allison, 2023 */
/* NetHack may be freely redistributed.  See license for details. */

#include "hack.h"

#ifdef DEBUG
#undef DEBUG
#endif

/* #import <Foundation/Foundation.h> */
#import <AppKit/AppKit.h>

/*
 * Sample sound interface for NetHack
 *
 * Replace 'macsound' with your soundlib name in this template file.
 * Should be placed in ../sound/macsound/.
 */

#define soundlib_macsound soundlib_nosound + 1

static void macsound_init_nhsound(void);
static void macsound_exit_nhsound(const char *);
static void macsound_achievement(schar, schar, int32_t);
static void macsound_soundeffect(char *, int32_t, int32_t);
static void macsound_hero_playnotes(int32_t, const char *, int32_t);
static void macsound_play_usersound(char *, int32_t, int32_t);
static int affiliate(int32_t seid, const char *soundname);

struct sound_procs macsound_procs = {
    SOUNDID(macsound),
//    SNDCAP_USERSOUNDS | SNDCAP_HEROMUSIC
//        | SNDCAP_ACHIEVEMENTS |SNDCAP_SOUNDEFFECTS,
     SNDCAP_USERSOUNDS | SNDCAP_HEROMUSIC | SNDCAP_SOUNDEFFECTS,
    macsound_init_nhsound,
    macsound_exit_nhsound,
    macsound_achievement,
    macsound_soundeffect,
    macsound_hero_playnotes,
    macsound_play_usersound,
};

/*
 *
 *  Types of potential sound supports (all are optionally implemented):
 *
 *      SNDCAP_USERSOUNDS     User-specified sounds that play based on config
 *                            file entries that identify a regular expression
 *                            to match against message window text, and identify
 *                            an external sound file to load in response.
 *                            The sound interface function pointer used to invoke
 *                            it:
 *
 *                             void (*sound_play_usersound)(char *filename,
 *                                             int32_t volume, int32_t idx);
 *
 *      SNDCAP_HEROMUSIC      Invoked by the core when the in-game hero is
 *                            playing a tune on an instrument. The sound
 *                            interface function pointer used to invoke it:
 *
 *                             void (*sound_hero_playnotes)(int32_t instrument,
 *                                                 char *str, int32_t volume);
 *
 *      SNDCAP_ACHIEVEMENTS   Invoked by the core when an in-game achievement
 *                            is reached. The soundlib routines could play
 *                            appropriate theme or mood music in response.
 *                            There would need to be a way to map the
 *                            achievements to external user-specified sounds.
 *                            The sound interface function pointer used to
 *                            invoke it:
 *
 *                                void (*sound_achievement)(schar, schar,
 *                                                          int32_t);
 *
 *      SNDCAP_SOUNDEFFECTS   Invoked by the core when something
 *                            sound-producing happens in the game. The soundlib
 *                            routines could play an appropriate sound effect
 *                            in response. They can be public-domain or
 *                            suitably-licensed stock sounds included with the
 *                            game source and made available during the build
 *                            process, or (not-yet-implemented) a way to
 *                            tie particular sound effects to a user-specified
 *                            sound macsounds in a config file. The sound
 *                            interface function pointer used to invoke it:
 *
 *                               void (*sound_soundeffect)(char *desc, int32_t,
 *                                                              int32_t volume);
 *
 * The routines below would call into your sound library.
 * to fulfill the functionality.
 */

static void
macsound_init_nhsound(void)
{
    /* Initialize external sound library */
}

static void
macsound_exit_nhsound(const char *reason UNUSED)
{
    /* Close / Terminate external sound library */

}

/* fulfill SNDCAP_ACHIEVEMENTS */
static void
macsound_achievement(schar ach1 UNUSED, schar ach2 UNUSED, int32_t repeat UNUSED)
{


}

/* magic number 40 is the current number of sound_ files to include */
#define EXTRA_SOUNDS 40

static int32_t affiliation[number_of_se_entries + EXTRA_SOUNDS] = { 0 };
static NSString *soundstring[number_of_se_entries + EXTRA_SOUNDS];
static NSSound *seSound[number_of_se_entries + EXTRA_SOUNDS];

/* fulfill SNDCAP_SOUNDEFFECTS */
static void
macsound_soundeffect(char *desc UNUSED, int32_t seid, int volume UNUSED)
{
#ifdef SND_SOUNDEFFECTS_AUTOMAP

  /* Supposedly, the following locations are searched in this order:
   *  1. the application’s main bundle
   *  2. ~/Library/Sounds
   *  3. /Library/Sounds
   *  4. /Network/Library/Sounds
   *  5. /System/Library/Sounds
   */

    char buf[1024];
    const char *soundname;

    if (seid <= se_zero_invalid || seid >= number_of_se_entries)
        return;
    if (!affiliation[seid]) {
        soundname = get_sound_effect_filename(seid, buf, sizeof buf, 1);
        if (soundname) {
            affiliate(seid, soundname);
        }
    }
    if (affiliation[seid]) {
        if ([seSound[seid] isPlaying])
            [seSound[seid] stop];
        [seSound[seid] play];
    }
#endif
}

#define WAVEMUSIC_SOUNDS

/*
 0 sound_Bell.wav
 1 sound_Drum_Of_Earthquake.wav
 2 sound_Fire_Horn.wav
 3 sound_Frost_Horn.wav
 4 sound_Leather_Drum.wav
 5 sound_Bugle_A.wav
 6 sound_Bugle_B.wav
 7 sound_Bugle_C.wav
 8 sound_Bugle_D.wav
 9 sound_Bugle_E.wav
10 sound_Bugle_F.wav
11 sound_Bugle_G.wav
12 sound_Magic_Harp_A.wav
13 sound_Magic_Harp_B.wav
14 sound_Magic_Harp_C.wav
15 sound_Magic_Harp_D.wav
16 sound_Magic_Harp_E.wav
17 sound_Magic_Harp_F.wav
18 sound_Magic_Harp_G.wav
19 sound_Tooled_Horn_A.wav
20 sound_Tooled_Horn_B.wav
21 sound_Tooled_Horn_C.wav
22 sound_Tooled_Horn_D.wav
23 sound_Tooled_Horn_E.wav
24 sound_Tooled_Horn_F.wav
25 sound_Tooled_Horn_G.wav
26 sound_Wooden_Flute_A.wav
27 sound_Wooden_Flute_B.wav
28 sound_Wooden_Flute_C.wav
29 sound_Wooden_Flute_D.wav
30 sound_Wooden_Flute_E.wav
31 sound_Wooden_Flute_F.wav
32 sound_Wooden_Flute_G.wav
33 sound_Wooden_Harp_A.wav
34 sound_Wooden_Harp_B.wav
35 sound_Wooden_Harp_C.wav
36 sound_Wooden_Harp_D.wav
37 sound_Wooden_Harp_E.wav
38 sound_Wooden_Harp_F.wav
39 sound_Wooden_Harp_G.wav
*/


/* fulfill SNDCAP_HEROMUSIC */
static void macsound_hero_playnotes(int32_t instrument,
                  const char *str, int32_t vol UNUSED)
{
#ifdef WAVEMUSIC_SOUNDS
    uint32_t pseudo_seid;
    boolean has_note_variations = FALSE;
    char resourcename[120], *end_of_res = 0;
    const char *c = 0;

    if (!str)
        return;
    resourcename[0] = '\0';
    switch(instrument) {
        case ins_tinkle_bell:
            Strcpy(resourcename, "sound_Bell");
            pseudo_seid = 0;
            break;
        case ins_taiko_drum:        /* DRUM_OF_EARTHQUAKE */
            Strcpy(resourcename, "sound_Drum_Of_Earthquake");
            pseudo_seid = 1;
            break;
        case ins_baritone_sax:      /* FIRE_HORN */
            Strcpy(resourcename, "sound_Fire_Horn");
            pseudo_seid = 2;
            break;
        case ins_french_horn:       /* FROST_HORN */
            Strcpy(resourcename, "sound_Frost_Horn");
            pseudo_seid = 3;
            break;
        case ins_melodic_tom:       /* LEATHER_DRUM */
            Strcpy(resourcename, "sound_Leather_Drum");
            pseudo_seid = 4;
            break;
        case ins_trumpet:           /* BUGLE */
            Strcpy(resourcename, "sound_Bugle");
            has_note_variations = TRUE;
            pseudo_seid = 5;
            break;
        case ins_cello:             /* MAGIC_HARP */
            Strcpy(resourcename, "sound_Magic_Harp");
            has_note_variations = TRUE;
            pseudo_seid = 12;
        case ins_english_horn:      /* TOOLED_HORN */
            Strcpy(resourcename, "sound_Tooled_Horn");
            has_note_variations = TRUE;
            pseudo_seid = 19;
            break;
        case ins_flute:             /* WOODEN_FLUTE */
            Strcpy(resourcename, "sound_Wooden_Flute");
            has_note_variations = TRUE;
            pseudo_seid = 26;
            break;
        case ins_orchestral_harp:   /* WOODEN_HARP */
            Strcpy(resourcename, "sound_Wooden_Harp");
            has_note_variations = TRUE;
            pseudo_seid = 33;
            break;
        case ins_pan_flute:         /* MAGIC_FLUTE */
             /* wav files for sound_Magic_Flute not added yet */
            Strcpy(resourcename, "sound_Wooden_Flute");
            has_note_variations = TRUE;
            pseudo_seid = 26;
            break;
    }
    pseudo_seid += number_of_se_entries; /* get past se_ entries */

    if (has_note_variations) {
        int i, idx = 0, notecount = strlen(str);
        static const char *const note_suffixes[]
                                = { "_A", "_B", "_C", "_D", "_E", "_F", "_G" };

        end_of_res = eos(resourcename);
        c = str;
        for (i = 0; i < notecount; ++i) {
            if (*c >= 'A' && *c <= 'G') {
                idx = (*c) - 'A';
                pseudo_seid += idx;
                if (pseudo_seid >= SIZE(affiliation))
			break;
                Strcpy(end_of_res, note_suffixes[idx]);
                if (!affiliation[pseudo_seid]) {
                    affiliate(pseudo_seid, resourcename);
                }
                if (affiliation[pseudo_seid]) {
                    if ([seSound[pseudo_seid] isPlaying])
                        [seSound[pseudo_seid] stop];
                    [seSound[pseudo_seid] play];
                }
            }
            c++;
        }
    } else {
        if (!affiliation[pseudo_seid]) {
            affiliate(pseudo_seid, resourcename);
        }
        if (affiliation[pseudo_seid]) {
            if ([seSound[pseudo_seid] isPlaying])
                [seSound[pseudo_seid] stop];
            [seSound[pseudo_seid] play];
        }
    }
#endif
}

/* fulfill  SNDCAP_USERSOUNDS */
static void
macsound_play_usersound(char *filename UNUSED, int volume UNUSED, int idx UNUSED)
{

}

static int
affiliate(int32_t seid, const char *soundname)
{
    if (!soundname || seid <= se_zero_invalid || seid >= SIZE(affiliation))
        return 0;

    if (!affiliation[seid]) {
        affiliation[seid] = seid;
        soundstring[seid] = [NSString stringWithUTF8String:soundname];
        seSound[seid] = [NSSound soundNamed:soundstring[seid]];
    }
    return 1;
}
/* end of macsound.m */

