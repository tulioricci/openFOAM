/*---------------------------------------------------------------------------*\
  =========                 |
  \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
   \\    /   O peration     | Website:  https://openfoam.org
    \\  /    A nd           | Copyright (C) YEAR OpenFOAM Foundation
     \\/     M anipulation  |
-------------------------------------------------------------------------------
License
    This file is part of OpenFOAM.

    OpenFOAM is free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    OpenFOAM is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License
    along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.

\*---------------------------------------------------------------------------*/

#include "forThermo.H"
#include "makeReactionThermo.H"

#include "specie.H"

#include "thermo.H"

// EoS
#include "perfectGas.H"

// Thermo
#include "janafThermo.H"
#include "sensibleInternalEnergy.H"

// Transport
#include "polynomialTransport.H"

// psi/rho
#include "rhoReactionThermo.H"
#include "heRhoThermo.H"

// Mixture
#include "coefficientMultiComponentMixture.H"


// * * * * * * * * * * * * * * * Global Functions  * * * * * * * * * * * * * //

extern "C"
{
    // dynamicCode:
    // SHA1 = f775461b78243c0a07acbc0bb33cf5dcb8b6173e
    //
    // Unique function name that can be checked if the correct library version
    // has been loaded
    void heRhoThermo_multiComponentMixture_polynomial_janaf_perfectGas_specie___sensibleInternalEnergy____f775461b78243c0a07acbc0bb33cf5dcb8b6173e(bool load)
    {
        if (load)
        {
            // code that can be explicitly executed after loading
        }
        else
        {
            // code that can be explicitly executed before unloading
        }
    }
}


// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

namespace Foam
{
    forThermo
    (
        polynomialTransport,
        sensibleInternalEnergy,
        janafThermo,
        perfectGas,
        specie,
        makeReactionThermo,
        rhoReactionThermo,
        heRhoThermo,
        coefficientMultiComponentMixture
    );
}


// ************************************************************************* //

