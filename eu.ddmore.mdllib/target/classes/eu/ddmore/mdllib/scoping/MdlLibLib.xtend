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