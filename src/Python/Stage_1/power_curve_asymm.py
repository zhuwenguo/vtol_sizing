#=========================================================================   
# Python wrapper to create a power curve for a particular design
#=========================================================================   

#=========================================================================   
# Import modules
#=========================================================================   

from calc_power            import calc_power 

#=========================================================================   
# Create dictionaries for easy data handling
#=========================================================================   

path        = '/home/yosemite/Dropbox/PrasadUM/'

#=========================================================================   
# Define flight condition parameters
#=========================================================================   

Flight      = {'V': 240, 'alt': 1500, 'rho': 0.002}   # knots, m, slug.cu.ft

#=========================================================================   
# Define vehicle design (lbs, sq.ft)
#=========================================================================   

Airframe    = {'Wt': 24938, 'f': 19.9, 'atype': 'asymmetric'} 

#=========================================================================   
# Define wing design: aspect ratio, wing lift fraction
#=========================================================================   

Wing        = {'AR': 7, 'fw': 0.5}     

#=========================================================================   
# Define rotor design: # blades, ft, lift offset, sol, adv. tip mach limit 
# Vtiph is in m/s
#=========================================================================   

Rotor       = {  'Nb': 4, 'Rft': 27.7, 'loff': 0.17, 'sigma': 0.09, 'Mtip': 0.8,
              'Vtiph': 240.0 , 'flap_freq': 1.2, 'NR': 1}

#=========================================================================   
# Blade properties: twist (nose down, deg), flap freq / rev (hover), 
# blade mass in kg (each blade) 
#=========================================================================   

Blade       = {'twist': 4.0, 'flap_freq': 1.2, 'mass': 120.0}

#=========================================================================   
# Pack all dictionaries into outer dict
#=========================================================================   

Aircraft    = {'Rotor': Rotor, 'Airframe': Airframe, 'Wing': Wing,
              'Flight': Flight,   'Blade': Blade }

#=========================================================================   
# Call power curve calculator (airspeed loop inside!)
#=========================================================================   

calc_power(Aircraft, path, 'Asymmetric/')

#=========================================================================   
# End of operations
#=========================================================================   
