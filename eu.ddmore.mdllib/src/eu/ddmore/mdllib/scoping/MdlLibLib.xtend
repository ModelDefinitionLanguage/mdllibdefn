/*******************************************************************************
 * Copyright (c) 2016 Pfizer Ltd.
 *
 * This file is part of the MDL Library.
 *
 * The MDL Library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * The MDL Library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with The MDL Library.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/
package eu.ddmore.mdllib.scoping

import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.ResourceSet
import com.google.inject.Provider
import org.eclipse.emf.common.util.URI

class MdlLibLib {
	public val static MAIN_LIB = "typelib.mlib"
	
	@Inject Provider<ResourceSet> resourceSetProvider;
	
	def loadLib() {
//		val stream = getClass().getClassLoader().getResourceAsStream(MAIN_LIB)
//		
//		resourceSetProvider.get() => [
//			resourceSet |
//			
//			val resource = resourceSet.createResource(URI::createURI(MAIN_LIB))
//			resource.load(stream, resourceSet.getLoadOptions())
//		]
		val rs = resourceSetProvider.get()
		loadIndivLib(rs, MAIN_LIB)
		rs
	}

	def private loadIndivLib(ResourceSet resourceSet, String path){
		val stream = getClass().getClassLoader().getResourceAsStream(path)
		val resource = resourceSet.createResource(URI::createURI(path))
		resource.load(stream, resourceSet.getLoadOptions())
	}
}