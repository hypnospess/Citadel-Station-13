//Defines for the hypnotic status effect and other associated things

//Bitflags for the hypnotic element. This determines what kind of behavior the hypnotic element will be keeping track of.
//Ideally, these flags should be restricted only to types of checks that are unreasonable to have handled by the object itself.
//This is primarily to allow for easier expansion of hypnotic element attachment behavior.
#define HYPNOTIC_ABSTRACT (1<<0) // This element is abstract. This allows the object's own code to handle it's hypnotic effects. This hooks into COMSIG_COMPONENT_HYPNO_ABSTRACT
#define HYPNOTIC_VIEW (1<<1) // This allows the element to be pinged in the hypnotic effect's view() check. This hooks into COMSIG_COMPONENT_HYPNO_VIEW

//Defines for the check_properties arg.
#define HYPNO_VIEWRANGE "hypno_viewrange"
#define HYPNO_VIEWRANGE_DEFAULT 7
#define HYPNO_VIEWSELF "hypno_viewself"
